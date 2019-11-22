local EventMgr = require("common.EventMgr")
local EventType = require("common.EventType")
local NetMgr = require("common.NetMgr")
local NetMsgId = require("common.NetMsgId")
local UserData = require("app.user.UserData")
local Common = require("common.Common")
local StaticData = require("app.static.StaticData")
local NetMsgId = require("common.NetMsgId")


local DissolutionLayer = class("DissolutionLayer", function()
    return ccui.Layout:create()
end)


function DissolutionLayer:create(player,data)
    local view = DissolutionLayer.new()
    view:onCreate(player,data)
    local function onEventHandler(eventType)  
        if eventType == "enter" then  
            view:onEnter() 
        elseif eventType == "exit" then
            view:onExit()
        elseif eventType == "cleanup" then
            view:onCleanup()
        end  
    end
    view:registerScriptHandler(onEventHandler)
    return view
end

function DissolutionLayer:onEnter()
    
end

function DissolutionLayer:onExit()
    
end

function DissolutionLayer:onCleanup()
end

function DissolutionLayer:onCreate(player,data)
    require("common.SceneMgr"):switchTips(self)
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local csb = cc.CSLoader:createNode("DissolutionLayer.csb")
    self:addChild(csb)
    self.root = csb:getChildByName("Panel_root")
    --进度动作
    local uiText_countdown = ccui.Helper:seekWidgetByName(self.root,"Text_countdown")
    uiText_countdown:setString(string.format("%d",data.dwDisbandedTime))
    uiText_countdown:runAction(cc.RepeatForever:create(cc.Sequence:create(
        cc.DelayTime:create(1),
        cc.CallFunc:create(function(sender,event) 
           uiText_countdown:setString(string.format("%d",data.dwDisbandedTime))
            data.dwDisbandedTime = data.dwDisbandedTime - 1
            if data.dwDisbandedTime < 0 then
                data.dwDisbandedTime = 0
            end
        end)
    )))
    
    local uiPanel_btn = ccui.Helper:seekWidgetByName(self.root,"Panel_btn")
    uiPanel_btn:setVisible(false)
    Common:addTouchEventListener(ccui.Helper:seekWidgetByName(self.root,"Button_agree"),function() 
        NetMgr:getGameInstance():sendMsgToSvr(NetMsgId.MDM_GR_USER,NetMsgId.REQ_GR_DISMISS_TABLE_REPLY,"o",true)
    end)
    Common:addTouchEventListener(ccui.Helper:seekWidgetByName(self.root,"Button_refuse"),function() 
        NetMgr:getGameInstance():sendMsgToSvr(NetMsgId.MDM_GR_USER,NetMsgId.REQ_GR_DISMISS_TABLE_REPLY,"o",false)
    end)

    -- local uiPanel_contents = ccui.Helper:seekWidgetByName(self.root,"Panel_contents8")
    -- uiPanel_contents:removeAllChildren()
	local uid = UserData.User.userID
    local playerId, name = self:disMissTableInfo(data)
    local isMine = uid == playerId

    local uiListView_content = ccui.Helper:seekWidgetByName(self.root,"ListView_content")
    local uiPanel_player = uiListView_content:getItem(0)
    uiPanel_player:retain()
    uiListView_content:removeAllItems()
    local color = cc.c3b(0,0,0)
    local refuseName = ""
    local advocateName = ""
    local isSwitch = true
    for i=1,8 do
        if data.dwUserIDALL[i] ~= 0 then
            local item = uiPanel_player:clone()
            uiListView_content:pushBackCustomItem(item)
            local uiText_name = ccui.Helper:seekWidgetByName(item,"Text_name")
            uiText_name:setTextColor(cc.c3b(0,0,0))
            uiText_name:setString(data.szNickNameALL[i])
            uiText_name:setFontName("fonts/DFYuanW7-GB2312.ttf")
            local uiText_tongyi = ccui.Helper:seekWidgetByName(item,"Text_tongyi")
            uiText_tongyi:setFontName("fonts/DFYuanW7-GB2312.ttf")
            if data.cbDisbandeState[i] == 1 then
                uiText_tongyi:setString("同意")
                uiText_tongyi:setTextColor(cc.c3b(255,255,0))
                if data.wAdvocateDisbandedID == i-1 then
                    advocateName = data.szNickNameALL[i]
                end
            elseif data.cbDisbandeState[i] == 2 then
                uiText_tongyi:setString("拒绝")
                uiText_tongyi:setTextColor(cc.c3b(255,255,0))
                refuseName = data.szNickNameALL[i]
                self:runAction(cc.Sequence:create(cc.DelayTime:create(0),cc.RemoveSelf:create()))
                require("common.MsgBoxLayer"):create(2,nil,string.format("%s拒绝解散房间",data.szNickNameALL[i])) 
                return
            else
                if data.dwUserIDALL[i] == UserData.User.userID then
                    uiPanel_btn:setVisible(true)
                end
                uiText_tongyi:setString("等待中")
                uiText_tongyi:setTextColor(cc.c3b(0,128,0))
            end     
        end
    end
    uiPanel_player:release()

    local uiwho_name = ccui.Helper:seekWidgetByName(self.root,"who_name")
    local uiname_state = ccui.Helper:seekWidgetByName(self.root,"name_state")
    if isMine then
		uiwho_name:setString('您')
		uiname_state:setString('请等待!')
	else
		uiwho_name:setString(name)
		uiname_state:setString('是否同意？')
	end
end


function DissolutionLayer:disMissTableInfo(data)
	local disPlayerID = nil
	local advocateName = ''
	for i = 1, 3 do
		if data.dwUserIDALL[i] ~= 0 then
			if data.cbDisbandeState[i] == 1 then --已经同意
				if data.wAdvocateDisbandedID == i - 1 then
					disPlayerID = data.dwUserIDALL[i] --谁发起
					advocateName = data.szNickNameALL[i] --谁发起
					break
				end
			end
		end
	end
	return disPlayerID, advocateName
end

return DissolutionLayer
    
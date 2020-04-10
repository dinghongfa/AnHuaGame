local GameCommon = require("game.anhua.GameCommon")
local EventType = require("common.EventType")
local EventMgr = require("common.EventMgr")
local Bit = require("common.Bit")
local StaticData = require("app.static.StaticData")
local Common = require("common.Common")
local GameLogic = require("game.anhua.GameLogic")
local GameEndLayer = class("GameEndLayer",function()
    return ccui.Layout:create()
end)
local cardPath = 'anhua/ui/smallend/'
function GameEndLayer:create(pBuffer)
    local view = GameEndLayer.new()
    view:onCreate(pBuffer)
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

function GameEndLayer:onEnter()
    EventMgr:registListener(EventType.SUB_GR_MATCH_TABLE_FAILED,self,self.SUB_GR_MATCH_TABLE_FAILED)
end

function GameEndLayer:onExit()
    EventMgr:unregistListener(EventType.SUB_GR_MATCH_TABLE_FAILED,self,self.SUB_GR_MATCH_TABLE_FAILED)
end

function GameEndLayer:onCleanup()

end

function GameEndLayer:onCreate(pBuffer)
    local csb = cc.CSLoader:createNode("AHGameLayerZiPai_End.csb")
    self:addChild(csb)
    self.root = csb:getChildByName("Panel_root")

    local uiButton_continue = ccui.Helper:seekWidgetByName(self.root,"Button_continue")
    uiButton_continue:setPressedActionEnabled(true)
    local function onEventContinue(sender,event)
    	if event == ccui.TouchEventType.ended then
            Common:palyButton()
            if GameCommon.tableConfig.nTableType > TableType_GoldRoom then
                if GameCommon.tableConfig.wTableNumber == GameCommon.tableConfig.wCurrentNumber then
                    EventMgr:dispatch(EventType.EVENT_TYPE_CACEL_MESSAGE_BLOCK)
                else
                    GameCommon:ContinueGame(GameCommon.tableConfig.cbLevel)
                end
            elseif GameCommon.tableConfig.nTableType == TableType_GoldRoom then 
                GameCommon:ContinueGame(GameCommon.tableConfig.cbLevel)
            else
                require("common.SceneMgr"):switchScene(require("app.MyApp"):create():createView("HallLayer"),SCENE_HALL) 
            end          
    	end
    end
    uiButton_continue:addTouchEventListener(onEventContinue)


    local uiAtlasLabel_jb = ccui.Helper:seekWidgetByName(self.root,"AtlasLabel_jb")
    local uiImage_iconjb = ccui.Helper:seekWidgetByName(self.root,"Image_iconjb")
    uiAtlasLabel_jb:setVisible(false)
    uiImage_iconjb:setVisible(false)
    local  integral = nil
	self.WPnumber = 0
	local number = 0
	--pBuffer.lGameScore[var.wChairID+1]
    for i=1 , GameCommon.gameConfig.bPlayerCount do
        if number < pBuffer.lGameScore[i] then 
            number = pBuffer.lGameScore[i]
        end

          
--           
--        end 
        print("玩家得分",pBuffer.lGameScore[i],number)    
    end  
    uiAtlasLabel_jb:setString(string.format(".%d",number))
    if GameCommon.tableConfig.nTableType  ~= TableType_GoldRoom or GameCommon.iscardcark == true then
        uiImage_iconjb:loadTexture("game/game_table_score.png")
    else
       -- uiImage_iconjb:setVisible(true)
    end
--    if pBuffer.lGameScore[i]  <= 0 then
--            uiAtlasLabel_jb:setProperty(string.format(".%d",integral),"fonts/fonts_12.png",26,45,'.')
--    end
    local uiPanel_result = ccui.Helper:seekWidgetByName(self.root,"Panel_result")
    local uiImage_result = ccui.Helper:seekWidgetByName(self.root,"Image_result")
    local viewID = GameCommon:getViewIDByChairID(pBuffer.wWinUser)
    local textureName = nil
    if viewID == 1 then --自己胜
        textureName = "anhua/ui/smallend/img_05.png"   
    elseif viewID == 2 then
        textureName = "anhua/ui/smallend/img_06.png"     
    elseif viewID == 3 then
        textureName = "anhua/ui/smallend/img_06.png"      
    end
    local texture = cc.Director:getInstance():getTextureCache():addImage(textureName)
    uiImage_result:loadTexture(textureName)
    uiImage_result:setContentSize(texture:getContentSizeInPixels())   
    local distance = 0
    if tricks == true then
        distance = -180
    end
    local uiPanel_look = ccui.Helper:seekWidgetByName(self.root,"Panel_look")
    
    if GameCommon.tableConfig.nTableType  ~= TableType_GoldRoom then
        uiImage_iconjb:loadTexture("game/game_table_score.png")
    end

    --结算信息
    local uiListView_info = ccui.Helper:seekWidgetByName(self.root,"ListView_info")
    local uiPanel_defaultInfo = ccui.Helper:seekWidgetByName(self.root,"Panel_defaultInfo")
    uiPanel_defaultInfo:retain()
    uiListView_info:removeAllItems()
    
    local item = uiPanel_defaultInfo:clone()
    local uiImage_name = ccui.Helper:seekWidgetByName(item,"Image_name")
    uiImage_name = ccui.ImageView:create(cardPath .. 'end_huxi.png')
    item:addChild(uiImage_name)
    uiImage_name:setAnchorPoint(cc.p(0,0.5))
    uiImage_name:setPosition(0,uiImage_name:getParent():getContentSize().height/2)


    local uiAtlasLabel_num = ccui.TextAtlas:create(string.format("%d",pBuffer.HuCardInfo.cbHuXiCount),cardPath .. "font.png",26,36,'/')
    item:addChild(uiAtlasLabel_num)
    uiAtlasLabel_num:setAnchorPoint(cc.p(1,0.5))
    uiAtlasLabel_num:setPosition(uiAtlasLabel_num:getParent():getContentSize().width,uiAtlasLabel_num:getParent():getContentSize().height/2)
    uiListView_info:pushBackCustomItem(item)
    
    -- local item = uiPanel_defaultInfo:clone()
    -- local uiImage_name = ccui.Helper:seekWidgetByName(item,"Image_name")
    -- uiImage_name = ccui.ImageView:create(cardPath .. 'phz_s_fs.png')
    -- item:addChild(uiImage_name)
    -- uiImage_name:setAnchorPoint(cc.p(0,0.5))
    -- uiImage_name:setPosition(0,uiImage_name:getParent():getContentSize().height/2)
    -- local uiAtlasLabel_num = ccui.TextAtlas:create(string.format("%d",pBuffer.wFanCount),cardPath .. "font.png",26,36,'/')
    -- item:addChild(uiAtlasLabel_num)
    -- uiAtlasLabel_num:setAnchorPoint(cc.p(1,0.5))
    -- uiAtlasLabel_num:setPosition(uiAtlasLabel_num:getParent():getContentSize().width,uiAtlasLabel_num:getParent():getContentSize().height/2)
    -- uiListView_info:pushBackCustomItem(item)
    
    local item = uiPanel_defaultInfo:clone()
    local uiImage_name = ccui.Helper:seekWidgetByName(item,"Image_name")
    uiImage_name = ccui.ImageView:create(cardPath .. "end_tun.png")
    item:addChild(uiImage_name)
    uiImage_name:setAnchorPoint(cc.p(0,0.5))
    uiImage_name:setPosition(0,uiImage_name:getParent():getContentSize().height/2)
    local uiAtlasLabel_num = ccui.TextAtlas:create(string.format("%d",pBuffer.wTun),cardPath .. "font.png",26,36,'/')
    item:addChild(uiAtlasLabel_num)
    uiAtlasLabel_num:setAnchorPoint(cc.p(1,0.5))
    uiAtlasLabel_num:setPosition(uiAtlasLabel_num:getParent():getContentSize().width,uiAtlasLabel_num:getParent():getContentSize().height/2)
    uiListView_info:pushBackCustomItem(item)

    if GameCommon.gameConfig.bStartTun > 0  then
        local item = uiPanel_defaultInfo:clone()
        local uiImage_name = ccui.Helper:seekWidgetByName(item,"Image_name")
        uiImage_name = ccui.ImageView:create(cardPath .. "end_jiayitun.png")
        item:addChild(uiImage_name)
        uiImage_name:setAnchorPoint(cc.p(0,0.5))
        uiImage_name:setPosition(0,uiImage_name:getParent():getContentSize().height/2)
        local uiAtlasLabel_num = ccui.TextAtlas:create(string.format("%d",1),cardPath .. "font.png",26,36,'/')
        item:addChild(uiAtlasLabel_num)
        uiAtlasLabel_num:setAnchorPoint(cc.p(1,0.5))
        uiAtlasLabel_num:setPosition(uiAtlasLabel_num:getParent():getContentSize().width,uiAtlasLabel_num:getParent():getContentSize().height/2)
        uiListView_info:pushBackCustomItem(item)
    end
    
    local item = uiPanel_defaultInfo:clone()
    local uiImage_name = ccui.Helper:seekWidgetByName(item,"Image_name")
    uiImage_name = ccui.ImageView:create(cardPath .. 'end_zf.png')
    item:addChild(uiImage_name)
    uiImage_name:setAnchorPoint(cc.p(0,0.5))
    uiImage_name:setPosition(0,uiImage_name:getParent():getContentSize().height/2)
    local scoreTun = pBuffer.wTun*pBuffer.wFanCount
    local uiAtlasLabel_num = ccui.TextAtlas:create(string.format("%d",scoreTun),cardPath .. "font.png",26,36,'/')
    item:addChild(uiAtlasLabel_num)
    uiAtlasLabel_num:setAnchorPoint(cc.p(1,0.5))
    uiAtlasLabel_num:setPosition(uiAtlasLabel_num:getParent():getContentSize().width,uiAtlasLabel_num:getParent():getContentSize().height/2)
    uiListView_info:pushBackCustomItem(item)



    uiPanel_defaultInfo:release()

    --积分
    local xscore = pBuffer.lGameScore[GameCommon.meChairID + 1]
    if not xscore then
        xscore = 0
    end
    self:updateScore(xscore)
    self:updateHeadImage(pBuffer)
    local ListView_Characterbox = nil
	local ListView_Characterbox4 = ccui.Helper:seekWidgetByName(self.root,"ListView_Characterbox4")
    ListView_Characterbox4:setVisible(false)    
    local ListView_Characterbox3 = ccui.Helper:seekWidgetByName(self.root,"ListView_Characterbox3")
    ListView_Characterbox3:setVisible(false)
    
    if GameCommon.gameConfig.bPlayerCount == 3 then
        --ListView_Characterbox3:setVisible(true)
        ListView_Characterbox = ListView_Characterbox3
    else
        --ListView_Characterbox4:setVisible(true)
        ListView_Characterbox = ListView_Characterbox4
    end 
    if GameCommon.gameConfig.bPlayerCount == 2 then
        local uiPanel_Characterbox3 = ccui.Helper:seekWidgetByName(ListView_Characterbox,"Panel_Characterbox3")
        ListView_Characterbox:removeItem(ListView_Characterbox:getIndex(uiPanel_Characterbox3))
        uiPanel_Characterbox3:setVisible(false)
        local uiPanel_Characterbox4 = ccui.Helper:seekWidgetByName(ListView_Characterbox,"Panel_Characterbox4")
        uiPanel_Characterbox4:setVisible(false)
        ListView_Characterbox:setPositionX(ListView_Characterbox:getContentSize().width/4)
    end
    for key, var in pairs(GameCommon.player) do
        local viewID = GameCommon:getViewIDByChairID(var.wChairID)           
        local root = ccui.Helper:seekWidgetByName(ListView_Characterbox,string.format("Panel_Characterbox%d",viewID))
        local uiImage_avatar = ccui.Helper:seekWidgetByName(root,"Image_avatar")
        Common:requestUserAvatar(var.dwUserID,var.szPto,uiImage_avatar,"img") 
        local uiText_name = ccui.Helper:seekWidgetByName(root,"Text_name")       
        uiText_name:setString(string.format("%s",var.szNickName)) 
        local uiText_ID = ccui.Helper:seekWidgetByName(root,"Text_ID")       
        uiText_ID:setString(string.format("ID:%s",var.dwUserID)) 
        local uiText_ZHX = ccui.Helper:seekWidgetByName(root,"Text_ZHX")
        local uiText_JSHX = ccui.Helper:seekWidgetByName(root,"Text_JSHX")
        uiText_ZHX:setVisible(false) 
        uiText_JSHX:setVisible(false) 
        local uiImage_yingjia = ccui.Helper:seekWidgetByName(root,"Image_yingjia")
        local uiAtlasLabel_money = ccui.Helper:seekWidgetByName(root,"Text_money")
       uiAtlasLabel_money:setFontSize(38)
        if GameCommon.tableConfig.nTableType == TableType_GoldRoom or GameCommon.tableConfig.nTableType  == TableType_SportsRoom then
            uiText_ID:setVisible(false)
        end 
        if GameCommon.tableConfig.nTableType  ~= TableType_GoldRoom then 
            if pBuffer.lGameScore[var.wChairID+1]  <= 0 then
                uiImage_yingjia:setVisible(false) 
                uiAtlasLabel_money:setString(string.format("%d积分",pBuffer.lGameScore[var.wChairID+1] ))
            else
                uiAtlasLabel_money:setString(string.format("+%d积分",pBuffer.lGameScore[var.wChairID+1] ))
            end
		else
            if pBuffer.lGameScore[var.wChairID+1]  <= 0 then
                uiImage_yingjia:setVisible(false) 
                uiAtlasLabel_money:setString(string.format("%d金币",pBuffer.lGameScore[var.wChairID+1] ))
            else
                uiAtlasLabel_money:setString(string.format("+%d金币",pBuffer.lGameScore[var.wChairID+1] ))
            end

        end
        print("玩家得分",pBuffer.lGameScore[var.wChairID+1],var.wChairID)  
    end

    --button_show--
    local button_show = ccui.Helper:seekWidgetByName(self.root,'button_show')
   
    self.button_show_press = button_show:getChildByName('press')
    self.isPress = true
    uiPanel_look:setVisible(self.isPress)
    Common:addTouchEventListener(button_show,function() 
        self.isPress = not self.isPress
        self.button_show_press:setVisible(self.isPress)
        uiPanel_look:setVisible(self.isPress)
        if self.isPress then
            EventMgr:dispatch('AHhideEndLayer',0)
        else
            EventMgr:dispatch('AHhideEndLayer',1)
        end
    end,true)
    local Button_close = ccui.Helper:seekWidgetByName(self.root,'Button_close')
    Common:addTouchEventListener(Button_close,function() 
        uiPanel_look:setVisible(false)
        self.button_result:setVisible(true)
        EventMgr:dispatch('AHhideEndLayer',1)
    end,true)

    self.button_result = ccui.Helper:seekWidgetByName(self.root,'button_result')
    self.button_result:setVisible(false)
    Common:addTouchEventListener(self.button_result,function() 
        uiPanel_look:setVisible(true)
        self.button_result:setVisible(false)
        EventMgr:dispatch('AHhideEndLayer',0)
    end,true)


    self:showPaiXing(pBuffer)
    self:showMingTang(pBuffer)
    self:showDiPai(pBuffer)
end

--刷新积分
function GameEndLayer:updateScore( tunScore) 
    local wChairID = GameCommon.meChairID

    local tunjifen = ccui.Helper:seekWidgetByName(self.root,"text_num_ju")
    tunjifen:setString(tunScore)
    local score =  GameCommon.player[wChairID].lScore
    local tun_total = ccui.Helper:seekWidgetByName(self.root,"text_num_total")
    local dwGold = Common:itemNumberToString(score)   
    tun_total:setString(tostring(dwGold))
end


function GameEndLayer:updateHeadImage(pBuffer)
    dump(pBuffer,'fx-------updateHeadImage------->>')
    local allAvatar = {}    
    local Panel = nil  
    local bPlayerCount = 3  
    local Panel_4 = ccui.Helper:seekWidgetByName(self.root,"Panel_4")
    Panel_4:setVisible(false)
    local Panel_3 = ccui.Helper:seekWidgetByName(self.root,"Panel_3")
    Panel_3:setVisible(false)
    Panel = Panel_3
    Panel:setVisible(true)
    for i=1, bPlayerCount do
        local avatar = nil
        if i == 1 then 
            avatar = ccui.Helper:seekWidgetByName(self.root,"Image_avatar_" .. i)
        else
            avatar = ccui.Helper:seekWidgetByName(Panel,"Image_avatar_" .. i)
        end 
        avatar:setVisible(false)
        table.insert( allAvatar,avatar)
    end
    local index = 2
    local item = nil
    for key, var in pairs(GameCommon.player) do
        print('--->>>>>>>>',pBuffer.wWinUser , var.dwUserID)
        if pBuffer.wWinUser == key then --赢家
            self:updateImageInfo(allAvatar[1],var,pBuffer.lGameScore[var.wChairID+1],pBuffer.lWriteScoreArr[var.wChairID+1])
        else
            self:updateImageInfo(allAvatar[index],var,pBuffer.lGameScore[var.wChairID+1],pBuffer.lWriteScoreArr[var.wChairID+1])
            index = index+1
        end
    end
end

function GameEndLayer:updateImageInfo(avatar, data,lGameScore,lWriteScoreArr)
    local item = avatar
    item:setVisible(true)
    Common:requestUserAvatar(data.dwUserID,data.szPto,item,"img")
    local name = item:getChildByName('name')
    name:setString(data.szNickName)
    local uiText_result = ccui.Helper:seekWidgetByName(item,"Text_result")
   
    uiText_result:setFontName("fonts/DFYuanW7-GB2312.ttf")
    if lGameScore >= 0 then 
        uiText_result:setTextColor(cc.c3b(175,49,52))
        uiText_result:setString(string.format("%d(赛:+%0.2f)",lGameScore,lWriteScoreArr/100))
    else      
        uiText_result:setTextColor(cc.c3b(0,128,0))
        uiText_result:setString(string.format("%d(赛:%0.2f)",lGameScore,lWriteScoreArr/100))
    end
end

--显示牌型和眼牌
function GameEndLayer:showPaiXing(pBuffer)
    local uiListView_weave = ccui.Helper:seekWidgetByName(self.root,"ListView_weave")
    local uiPanel_defaultWeave = ccui.Helper:seekWidgetByName(self.root,"Panel_defaultWeave")
    uiPanel_defaultWeave:retain()
    uiListView_weave:removeAllChildren()
    local isAddHuPai = false


    for WeaveItemIndex = 1 , pBuffer.HuCardInfo.cbWeaveCount do
        local   WeaveItemArray= pBuffer.HuCardInfo.WeaveItemArray[WeaveItemIndex]            --组合扑克
        if not WeaveItemArray then
            break
        end
        pBuffer.HuCardInfo.WeaveItemArray[WeaveItemIndex].isHupai = 0 
        if pBuffer.HuCardInfo.cbWeaveCount<=6 and pBuffer.HuCardInfo.cbCardEye ~=0  and pBuffer.HuCardInfo.cbCardEye == pBuffer.cbHuCard then
        else
            for i = 1 , WeaveItemArray.cbCardCount do
                local data = WeaveItemArray.cbCardList[i]
                local _spt=GameCommon:getDiscardCardAndWeaveItemArray(data)
                if data == pBuffer.cbHuCard and not isAddHuPai then --胡牌
                    local a = true
                    if WeaveItemArray.cbWeaveKind == GameCommon.ACK_WEI then                   
                        for num_Weave = WeaveItemIndex +1 , pBuffer.HuCardInfo.cbWeaveCount do
                            local WeaveItemArray_1= pBuffer.HuCardInfo.WeaveItemArray[num_Weave]            --组合扑克
                            for i = 1 , WeaveItemArray_1.cbCardCount do
                                local data = WeaveItemArray_1.cbCardList[i]
                                if data == pBuffer.cbHuCard then --胡牌
                                    a = false
                                end 
                            end 
                        end    
                        if a == true then 
                            pBuffer.HuCardInfo.WeaveItemArray[WeaveItemIndex].isHupai = 3
                            isAddHuPai = true
                        end  
                    elseif WeaveItemArray.cbWeaveKind == GameCommon.ACK_TI  then 
                        pBuffer.HuCardInfo.WeaveItemArray[WeaveItemIndex].isHupai = 4
                        isAddHuPai = true              
                    end              
                end
                if data == pBuffer.cbHuCard and not isAddHuPai  then --胡牌
                    pBuffer.HuCardInfo.WeaveItemArray[WeaveItemIndex].isHupai = i
                    isAddHuPai = true
                end
            end
        end 
    end

    for WeaveItemIndex = 1 , pBuffer.HuCardInfo.cbWeaveCount do
        local item = uiPanel_defaultWeave:clone()
        print('============>>显示牌型和眼牌',WeaveItemIndex)
        dump(pBuffer)
        local   WeaveItemArray= pBuffer.HuCardInfo.WeaveItemArray[WeaveItemIndex]            --组合扑克
        if not WeaveItemArray then
            break
        end
        local iscbCenterCard = nil
        if WeaveItemArray.cbWeaveKind == GameCommon.ACK_CHI then
            iscbCenterCard = false
        end 
        
        for i = 1 , WeaveItemArray.cbCardCount do
            local data = WeaveItemArray.cbCardList[i]
            local _spt=GameCommon:getDiscardCardAndWeaveItemArray(data)
            -- if data == pBuffer.cbHuCard and not isAddHuPai then --胡牌
            --     local a = true
            --     if WeaveItemArray.cbWeaveKind == GameCommon.ACK_WEI then                   
            --         for num_Weave = WeaveItemIndex +1 , pBuffer.HuCardInfo.cbWeaveCount do
            --             local WeaveItemArray_1= pBuffer.HuCardInfo.WeaveItemArray[num_Weave]            --组合扑克
            --             for i = 1 , WeaveItemArray_1.cbCardCount do
            --                 local data = WeaveItemArray_1.cbCardList[i]
            --                 if data == pBuffer.cbHuCard then --胡牌
            --                     a = false
            --                 end 
            --             end 
            --         end    
            --         if a == true and i == 3  then 
            --             local di = cc.Sprite:create('anhua/ui/smallend/img_15.png')
            --             _spt:addChild(di)
            --             local size = _spt:getContentSize()
            --             di:setPosition(size.width / 2,size.height / 2)
            --             dump(size,'======================>>>')
            --             isAddHuPai = true
            --         end  
            --     elseif WeaveItemArray.cbWeaveKind == GameCommon.ACK_TI and i == 4 then 
            --         local di = cc.Sprite:create('anhua/ui/smallend/img_15.png')
            --         _spt:addChild(di)
            --         local size = _spt:getContentSize()
            --         di:setPosition(size.width / 2,size.height / 2)
            --         dump(size,'======================>>>')
            --         isAddHuPai = true              
            --     end              
            -- end
            if WeaveItemArray.cbWeaveKind == GameCommon.ACK_CHI and iscbCenterCard == false and data == WeaveItemArray.cbCenterCard then
                iscbCenterCard  = true
                _spt:setColor(cc.c3b(170,170,170))
            end 
            if WeaveItemArray.cbWeaveKind == GameCommon.ACK_WEI and i ~= 3 then
                -- if cardBgIndex == 1 then
                --     _spt = ccui.ImageView:create("anhua/card_bg/card_bg1/card_bg_2.png")
                -- elseif cardBgIndex == 2 then
                    _spt = ccui.ImageView:create("anhua/card_bg/card_bg2/card_bg_2.png")
                -- else
                --     _spt = ccui.ImageView:create("anhua/card_bg/card_bg0/card_bg_2.png")
                -- end
            elseif WeaveItemArray.cbWeaveKind == GameCommon.ACK_TI and i ~= 4 then
                -- if cardBgIndex == 1 then
                --     _spt = ccui.ImageView:create("anhua/card_bg/card_bg1/card_bg_2.png")
                -- elseif cardBgIndex == 2 then
                    _spt = ccui.ImageView:create("anhua/card_bg/card_bg2/card_bg_2.png")
                -- else
                --     _spt = ccui.ImageView:create("anhua/card_bg/card_bg0/card_bg_2.png")
                -- end
            end
            if data == pBuffer.cbHuCard  and pBuffer.HuCardInfo.WeaveItemArray[WeaveItemIndex].isHupai == i then --胡牌
                local di = cc.Sprite:create('anhua/ui/smallend/img_15.png')
                _spt:addChild(di)
                local size = _spt:getContentSize()
                di:setPosition(size.width / 2,size.height / 2)
                dump(size,'======================>>>')
            end
            _spt:setPosition(cc.p(0,(i - 1)*GameCommon.CARD_HUXI_HEIGHT))
            _spt:setAnchorPoint(cc.p(0,0))
            item:addChild(_spt)
        end

        local WeaveType=self:getSptWeaveType(WeaveItemArray.cbWeaveKind)
        WeaveType:setPosition(cc.p(GameCommon.CARD_HUXI_WIDTH*0.5,5*GameCommon.CARD_HUXI_HEIGHT))
        item:addChild(WeaveType)

        local huxicout=GameLogic:GetWeaveHuXi(clone(WeaveItemArray))
        local Weavecout=cc.Label:createWithSystemFont(string.format("%d",huxicout), "Arial", 30)
        Weavecout:setPosition(cc.p(GameCommon.CARD_HUXI_WIDTH*0.5,-GameCommon.CARD_HUXI_HEIGHT + 20))
        item:addChild(Weavecout)

        uiListView_weave:pushBackCustomItem(item)
    end
    uiPanel_defaultWeave:release()
    --眼牌
    if pBuffer.HuCardInfo.cbWeaveCount<=6 and pBuffer.HuCardInfo.cbCardEye ~=0 then
        local item = uiPanel_defaultWeave:clone()
        for i = 0 , 1 do
            local data = pBuffer.HuCardInfo.cbCardEye
            local _spt=GameCommon:getDiscardCardAndWeaveItemArray(data)
            _spt:setPosition(cc.p(0,i*GameCommon.CARD_HUXI_HEIGHT))
            _spt:setAnchorPoint(cc.p(0,0))
            item:addChild(_spt)

            if data == pBuffer.cbHuCard and not isAddHuPai and i == 1 then --胡牌
                local di = cc.Sprite:create('anhua/ui/smallend/img_15.png')
                _spt:addChild(di)
                local size = _spt:getContentSize()
                di:setPosition(size.width / 2,size.height / 2)
                dump(size,'======================>>>')
                isAddHuPai = true
            end
            
        end
        uiListView_weave:pushBackCustomItem(item)
    end 
end

--显示名堂
function GameEndLayer:showMingTang(pBuffer)
    self.PHZ_HT_DUIDUIHU = 64              --对对胡   全部对子                                                                                                                                                (X 4倍)
--    self.PHZ_HT_DA = 128              --胡牌时，玩家的牌中，大字>=18只  X6（以18只为基数（6番），每多1只大字加1番）                          (x 6倍)

    --@
    self.PHZ_HT_XIAO = 0x0100              --十八小:即胡牌时手中的小牌大于或等于18张(6番)
    self.PHZ_HT_HEIWU  = 0x0020            --黑胡(板胡):即胡牌时手中没有红牌(5番) 
    self.PHZ_HT_HONGWU = 0x0010            --十三红(甲火胡):即胡牌时手中的红牌大于或等于13张(4番）
    self.PHZ_HT_ZHENGDIANHU = 0x0004       --点胡:即胡牌时手中的红牌只有l张(3番)。
    self.PHZ_HT_HONGHU  = 0x0002 --红胡〔火胡):即胡牌时手中的红牌大于或等于10张,小于13张(2番)
    self.PHZ_HT_ZIMO	= 0x0001 --自摸

    self.PHZ_HT_SHUAHOU = 0x1000 --爬坡
    self.PHZ_HT_DIANDENG		=				0x2000 --持续爬坡
    self.PHZ_HT_HAIDI = 512              --玩家所胡的牌是墩中最后的一只牌  平胡加1番，名堂胡加2番                                                                     (X 2倍)
    self.PHZ_HT_TIANHU = 0x0400              --庄家或闲家所胡的牌为亮张牌 不加番，但息数×2；如果又是名堂胡，则先计算息数，再计算底数，     (X 4倍)
    
    self.PHZ_HT_DIHU                       = 0x0800              --听胡(6) 起上来.玩家手中的牌有≥15息不进牌直接胡的（只要进牌不打牌出去的）                      (X 6倍)
--    self.PHZ_HT_SHUAHOU                      = 0x1000              --耍猴(8) 玩家手中的牌打的只剩一只单调胡牌的  番数：8番                                        (X 8倍)
--    self.PHZ_HT_HUANGFAN                     = 0x2000              --黄番(Na)    黄庄了.下把牌继续打所有番番一倍（只适合开房）
    
    local uiListView_player = ccui.Helper:seekWidgetByName(self.root,"ListView_player")
    local uiPanel_defaultPalyer = ccui.Helper:seekWidgetByName(self.root,"Panel_defaultPalyer")
    uiPanel_defaultPalyer:retain()
    uiListView_player:removeAllItems()
    -- 变量定义 
    local wHZCount = 0 
    local wDZCount = 0
    local wXZCount = 0
    local bIsDDH = true
    local sdata = {
        wTun = 0 ,          --囤
        wType = 0 ,         --数据
        wFanCount = 0,      --翻
    }
    --组合牌类型
    for cbIndex = 1 , pBuffer.HuCardInfo.cbWeaveCount do
        --变量定义
        if not pBuffer.HuCardInfo.WeaveItemArray[cbIndex] then
            break
        end
        local cbWeaveKind = pBuffer.HuCardInfo.WeaveItemArray[cbIndex].cbWeaveKind
        local cbWeaveCardCount = pBuffer.HuCardInfo.WeaveItemArray[cbIndex].cbCardCount

        --合法验证
        if cbWeaveKind ~= 0 then
            --组合内统计
            for cbCardIndex = 1 , cbWeaveCardCount do
                if pBuffer.HuCardInfo.WeaveItemArray[cbIndex].cbCardList[cbCardIndex] ~= 0 then
                    --大小字统计
                    if Bit:_and(pBuffer.HuCardInfo.WeaveItemArray[cbIndex].cbCardList[cbCardIndex] , GameCommon.MASK_COLOR) == 16 then
                        wDZCount = wDZCount + 1
                    else 
                        wXZCount = wXZCount + 1
                    end

                    --红字统计
                    if Bit:_and(pBuffer.HuCardInfo.WeaveItemArray[cbIndex].cbCardList[cbCardIndex] , GameCommon.MASK_VALUE)==2 
                        or Bit:_and(pBuffer.HuCardInfo.WeaveItemArray[cbIndex].cbCardList[cbCardIndex] , GameCommon.MASK_VALUE)==7 
                        or Bit:_and(pBuffer.HuCardInfo.WeaveItemArray[cbIndex].cbCardList[cbCardIndex] , GameCommon.MASK_VALUE)==10 then
                        wHZCount = wHZCount + 1
                    end
                end
            end
            --对对胡判断
            if cbWeaveKind== GameCommon.ACK_CHI or cbWeaveKind==GameCommon.ACK_CHI_EX then
                bIsDDH=false
            end
        end
    end
    --眼牌
    if pBuffer.HuCardInfo.cbCardEye~=0 then
        for  i=1 , 2 do
            --大小字统计
            if Bit:_and(pBuffer.HuCardInfo.cbCardEye , GameCommon.MASK_COLOR) == 16 then
                wDZCount = wDZCount + 1

            else 

                wXZCount = wXZCount + 1
            end
            --红字统计
            if Bit:_and(pBuffer.HuCardInfo.cbCardEye , GameCommon.MASK_VALUE)==2  
                or Bit:_and(pBuffer.HuCardInfo.cbCardEye, GameCommon.MASK_VALUE)==7 
                or Bit:_and(pBuffer.HuCardInfo.cbCardEye, GameCommon.MASK_VALUE)==10 then

                wHZCount = wHZCount + 1
            end
        end
    end
    
    if wHZCount>=10 then
        --红胡
        -- local item = uiPanel_defaultPalyer:clone()
        -- self:createMingTang(item,"honghu",2 +wHZCount-10,"","fan")
        -- uiListView_player:pushBackCustomItem(item)
    end
  


    -- --对对胡=没有吃进的组合、手中没有单牌
    -- if Bit:_and(pBuffer.wType,self.PHZ_HT_DUIDUIHU) ~= 0 then
    --     local item = uiPanel_defaultPalyer:clone()
    --     self:createMingTang(item,"duiduihu",4,"","fan")
    --     uiListView_player:pushBackCustomItem(item)
    -- end
    -- if wDZCount >= 18 and wDZCount < 27 then
    --     local item = uiPanel_defaultPalyer:clone()
    --     self:createMingTang(item,"dazihu",4+wDZCount-18,"","fan")
    --     uiListView_player:pushBackCustomItem(item)

    -- elseif wXZCount >= 16 and wXZCount < 27 then
    --     local item = uiPanel_defaultPalyer:clone()
    --     self:createMingTang(item,"xiaozihu",4+wXZCount-16,"","fan") 
    --     uiListView_player:pushBackCustomItem(item)

    -- end
    -- -- 海底
    -- if Bit:_and(pBuffer.wType , self.PHZ_HT_HAIDI) ~= 0 then
    --     local item = uiPanel_defaultPalyer:clone()
    --     self:createMingTang(item,"haidihu",2,"","fan")
    --     uiListView_player:pushBackCustomItem(item)
    -- end
    -- if Bit:_and(pBuffer.wType,self.PHZ_HT_TIANHU) ~= 0 then
    --     local item = uiPanel_defaultPalyer:clone()
    --     self:createMingTang(item,"tianhu",4,"","fan")
    --     uiListView_player:pushBackCustomItem(item)
    -- end
    -- if Bit:_and(pBuffer.wType,self.PHZ_HT_DIHU) ~= 0 then
    --     local item = uiPanel_defaultPalyer:clone()
    --     self:createMingTang(item,"dihu",3,"","fan")
    --     uiListView_player:pushBackCustomItem(item)
    -- end

    --十八小
    if Bit:_and(pBuffer.wType,self.PHZ_HT_XIAO) ~= 0 then
        local item = uiPanel_defaultPalyer:clone()
        self:createMingTang(item,"18")
        uiListView_player:pushBackCustomItem(item)
    end

    --黑胡
    if Bit:_and(pBuffer.wType,self.PHZ_HT_HEIWU) ~= 0 then
        local item = uiPanel_defaultPalyer:clone()
        self:createMingTang(item,"heihu") 
        uiListView_player:pushBackCustomItem(item)
    end

    --十三红
    if Bit:_and(pBuffer.wType,self.PHZ_HT_HONGWU) ~= 0 then
        local item = uiPanel_defaultPalyer:clone()
        self:createMingTang(item,"13") 
        uiListView_player:pushBackCustomItem(item)
    end

    --点胡
    if Bit:_and(pBuffer.wType,self.PHZ_HT_ZHENGDIANHU) ~= 0 then
        local item = uiPanel_defaultPalyer:clone()
        self:createMingTang(item,"dianhu")
        uiListView_player:pushBackCustomItem(item)
        
    end

    --红胡
    if Bit:_and(pBuffer.wType,self.PHZ_HT_HONGHU) ~= 0 then
        local item = uiPanel_defaultPalyer:clone()
        self:createMingTang(item,"honghu")
        uiListView_player:pushBackCustomItem(item)
        
    end

    local papo = GameCommon.gameConfig.bPaPo

    if papo ~= 0 and GameCommon.huangfanNum and GameCommon.huangfanNum ~= 0 then
        local item = nil
        if papo == 1 then --爬坡
            item = uiPanel_defaultPalyer:clone()
            self:createMingTang(item,"papo",2)
        elseif papo == 2 then --持续爬坡
            item = uiPanel_defaultPalyer:clone()
            local huangfanNum = 1
            if GameCommon.huangfanNum>= 1 then 
                for i = 1 , GameCommon.huangfanNum do 
                    huangfanNum = huangfanNum*2 
                end 
            end 
            self:createMingTang(item,"papo",huangfanNum)
        elseif papo == 3 then --爬2坡
            item = uiPanel_defaultPalyer:clone()
            if GameCommon.huangfanNum <= 2 then
                self:createMingTang(item,"papo",GameCommon.huangfanNum*2)
            else
                self:createMingTang(item,"papo",4)
            end 
        end
        uiListView_player:pushBackCustomItem(item)
    end

    --自摸判断
    if Bit:_and(pBuffer.wType,self.PHZ_HT_ZIMO)~= 0 then
        local item = uiPanel_defaultPalyer:clone()
        self:createMingTang(item,"zimo")
        uiListView_player:pushBackCustomItem(item)
        
    end  
    
    uiPanel_defaultPalyer:release()
end

function GameEndLayer:createMingTang(item,mingTang,num,numType,unit)
    local uiImage_name = ccui.ImageView:create(string.format(cardPath .. "end_play_%s.png",mingTang))
    item:addChild(uiImage_name)
    uiImage_name:setAnchorPoint(cc.p(0,0.5))
    uiImage_name:setPosition(cc.p(-uiImage_name:getParent():getContentSize().width*0.2,uiImage_name:getParent():getContentSize().height/2))
    if num and num ~= 0 then
        local uiAtlasLabel_num = ccui.TextAtlas:create(string.format(".%d",num),"fonts/fonts_9.png",18,27,'.')
        item:addChild(uiAtlasLabel_num)
        uiAtlasLabel_num:setAnchorPoint(cc.p(1,0.5))
        uiAtlasLabel_num:setPosition(cc.p(uiAtlasLabel_num:getParent():getContentSize().width*0.5 + 60,uiAtlasLabel_num:getParent():getContentSize().height/2))
    end
end

--显示底牌
function GameEndLayer:showDiPai(pBuffer)
    local uiListView_diPai1 = ccui.Helper:seekWidgetByName(self.root,"ListView_diPai1")
    local uiListView_diPai2 = ccui.Helper:seekWidgetByName(self.root,"ListView_diPai2")
    for i = 1, pBuffer.bLeftCardCount do
        if pBuffer.bLeftCardDataEx[i] ~= 0 then
            local item = GameCommon:GetCardHand(pBuffer.bLeftCardDataEx[i],true)
            if i<= 17 then
                uiListView_diPai1:pushBackCustomItem(item)
            else
                uiListView_diPai2:pushBackCustomItem(item)
            end
        end
    end
end

function GameEndLayer:getSptWeaveType(type)
    local sptname = ""
    if type == GameCommon.ACK_TI then
        sptname= cardPath .. 'endlayer13.png'
    elseif type == GameCommon.ACK_PAO then
        sptname= cardPath .. 'endlayer6.png'
    elseif type == GameCommon.ACK_WEI then
        sptname= cardPath .. 'endlayer5.png'
    elseif type == GameCommon.ACK_CHI then
        sptname= cardPath .. 'phz_s_chi.png'
    elseif type == GameCommon.ACK_PENG then 
        sptname= cardPath .. 'phz_s_peng.png'
    else
       
    end
    return cc.Sprite:create(sptname)
end

function GameEndLayer:SUB_GR_MATCH_TABLE_FAILED(event)
    local data = event._usedata
    require("common.SceneMgr"):switchScene(require("app.MyApp"):create():createView("HallLayer"),SCENE_HALL) 
    if data.wErrorCode == 0 then
        require("common.MsgBoxLayer"):create(0,nil,"您在游戏中!")
    elseif data.wErrorCode == 1 then
        require("common.MsgBoxLayer"):create(0,nil,"游戏配置发生错误!")
    elseif data.wErrorCode == 2 then
        if  StaticData.Hide[CHANNEL_ID].btn8 == 1 and StaticData.Hide[CHANNEL_ID].btn9 == 1  then
            require("common.MsgBoxLayer"):create(2,nil,"您的金币不足,请前往商城充值!",function() require("common.SceneMgr"):switchOperation(require("app.MyApp"):create(2):createView("NewMallLayer")) end)
        else
            require("common.MsgBoxLayer"):create(1,nil,"您的金币不足,请联系代理购买！",function() require("common.SceneMgr"):switchOperation(require("app.MyApp"):create():createView("GuilLayer"))  end)
        end
    elseif data.wErrorCode == 3 then
        require("common.MsgBoxLayer"):create(0,nil,"您的金币已超过上限，请前往更高一级匹配!")
    elseif data.wErrorCode == 4 then
        require("common.MsgBoxLayer"):create(0,nil,"房间已满,稍后再试!")
    else
        require("common.MsgBoxLayer"):create(0,nil,"未知错误,请升级版本!") 
    end
end

return GameEndLayer

--[[
*名称:NewClubInfoLayer
*描述:亲友圈桌子
*作者:admin
*创建日期:2018-06-14 11:22:00
*修改日期:2018-09-25 09:57:35
]]

local EventMgr              = require("common.EventMgr")
local EventType             = require("common.EventType")
local NetMgr                = require("common.NetMgr")
local NetMsgId              = require("common.NetMsgId")
local StaticData            = require("app.static.StaticData")
local UserData              = require("app.user.UserData")
local Common                = require("common.Common")
local Default               = require("common.Default")
local GameConfig            = require("common.GameConfig")
local Log                   = require("common.Log")
local HttpUrl               = require("common.HttpUrl")
local Base64                = require("common.Base64")
local Bit                   = require("common.Bit")

local DefaultTblNum         = 24
local TableScale            = 1
local CellSize = cc.size(300, 480)

local NewClubInfoLayer      = class("NewClubInfoLayer", cc.load("mvc").ViewBase)

function NewClubInfoLayer:onConfig()
    self.widget             = {
        {"Image_bg"},
        {"Panel_bg"},
        {"Panel_ui"},
        -- {"Image_head"},
        {"Text_clubName"},
        {"Text_clubID"},
        {"Text_clubPeople"},

        {"Panel_broadcast"},
        {"Text_broadcast"},

        {"Button_return", "onReturn"},
        {"Button_playway", "onPlayWay"},
        {"Button_share", "onShare"},
        {"Button_mem", "onMember"},
        {"Image_checkRedPoint"},
        {"Image_chatRedPoint"},
        {"Button_statistics", "onStatistics"},
        {"Button_mgr", "onManager"},
        {"Button_tblItem"},
        {"Button_quickStart", "onQuickStart"},
        {"Text_lastRecordName"},
        {"Button_custom", "onCustomRoom"},
        -- {"Button_chat", "onChat"},
        {"Image_playWayInfo"},
        {"Image_noSetWayFlag"},
        {"Image_contextTips"},

        {"Button_moreClub","onMoreClub"},
        {"Image_moreClubFrame"},
        {"ListView_more"},
        {"Button_item"},
        {"Button_createClub","onCreateClub"},
        {"Button_joinClub","onJoinClub"},
        {"Text_pilaozhi"},
        {"Button_shareChat", "onShareChat"},

        {"Button_mp", "onMingPian"},
        {"Panel_mp"},
        {"Image_mpFrame"},
        {"Image_mp"},
        {"Button_modifymp", "onModifyMp"},

        {"Button_partner", "onPartner"},
        {"Button_give", "onGive"},
        {"Button_notice", "onNotice"},
        {"Button_fatigue", "onFatigue"},

        {"Button_isShow", "onIsSHow"},
        {"Panel_topRight"},
        {"Image_bottom"},
        {"Image_moneyIcon"},
        {"Button_zjShare", "onZJShare"},
        {"Text_yuanbaoNum"},
        {"Button_addYB", "onAddYB"},
        {"Button_ybFrame"},
        {"Image_lAntiValue"},
        {"Text_lAntiValue"},
        {"Button_fkFrame"},
        {"Text_fkNum"},

        {"Panel_tempNotice"},
        {"Button_tempClose", "onTempClose"},
		{"Text_tempNotice"},
		
		{"Node_tableView"},
    }
    self.clubData           = {}      --亲友圈大厅数据
    self.userOffice         = 2       --普通成员
    self.userFatigueValue   = 0       --用户疲劳值
    self.playwayData        = {}
	self.allTableData       = {}
	self.tableViewLength 	= 0
	self.isTableViewRefresh = false
end

function NewClubInfoLayer:onEnter()
    EventMgr:registListener(EventType.RET_GET_CLUB_TABLE,self,self.RET_GET_CLUB_TABLE)
    EventMgr:registListener(EventType.RET_REFRESH_CLUB,self,self.RET_REFRESH_CLUB)
    EventMgr:registListener(EventType.RET_ADD_CLUB_TABLE,self,self.RET_ADD_CLUB_TABLE)
    EventMgr:registListener(EventType.RET_UPDATE_CLUB_TABLE,self,self.RET_UPDATE_CLUB_TABLE)
    EventMgr:registListener(EventType.RET_DEL_CLUB_TABLE,self,self.RET_DEL_CLUB_TABLE)
    EventMgr:registListener(EventType.RET_UPDATE_CLUB_INFO,self,self.RET_UPDATE_CLUB_INFO)
    EventMgr:registListener(EventType.RET_DELED_CLUB,self,self.RET_DELED_CLUB)
    EventMgr:registListener(EventType.RET_CLUB_CHECK_LIST,self,self.RET_CLUB_CHECK_LIST)
    EventMgr:registListener(EventType.SUB_CL_LOGON_SUCCESS,self,self.SUB_CL_LOGON_SUCCESS)
    EventMgr:registListener(EventType.EVENT_TYPE_DID_ENTER_BACKGROUND,self,self.EVENT_TYPE_DID_ENTER_BACKGROUND)
    EventMgr:registListener(EventType.EVENT_TYPE_WILL_ENTER_FOREGROUND,self,self.EVENT_TYPE_WILL_ENTER_FOREGROUND)
    EventMgr:registListener(EventType.RET_GET_CLUB_LIST,self,self.RET_GET_CLUB_LIST)
    EventMgr:registListener(EventType.RET_GET_CLUB_LIST_FAIL,self,self.RET_GET_CLUB_LIST_FAIL)
    EventMgr:registListener(EventType.RET_ADDED_CLUB,self,self.RET_ADDED_CLUB)
    EventMgr:registListener(EventType.RET_UPDATE_CLUB_ROOMCARD,self,self.RET_UPDATE_CLUB_ROOMCARD)
    EventMgr:registListener(EventType.RET_REFRESH_CLUB_PLAY,self,self.RET_REFRESH_CLUB_PLAY)
    EventMgr:registListener(EventType.RET_REFRESH_CLUB_PLAY_FINISH,self,self.RET_REFRESH_CLUB_PLAY_FINISH)
    EventMgr:registListener(EventType.RET_UPDATE_CLUB_PLAYER_INFO ,self,self.RET_UPDATE_CLUB_PLAYER_INFO)
    EventMgr:registListener(EventType.RET_SETTINGS_CLUB_MEMBER ,self,self.RET_SETTINGS_CLUB_MEMBER)
    EventMgr:registListener(EventType.SUB_CL_USER_INFO ,self,self.SUB_CL_USER_INFO)
    EventMgr:registListener(EventType.RET_SETTINGS_CONFIG ,self,self.RET_SETTINGS_CONFIG)
    EventMgr:registListener(EventType.RET_CLUB_CHAT_GET_UNREAD_MSG, self, self.RET_CLUB_CHAT_GET_UNREAD_MSG)
    EventMgr:registListener(EventType.REFRESH_CLUB_BG, self, self.REFRESH_CLUB_BG)
    EventMgr:registListener(EventType.RET_CLUB_SETTING_ANTI_MEMBER,self,self.RET_CLUB_SETTING_ANTI_MEMBER)
    cc.UserDefault:getInstance():setStringForKey("UserDefault_Operation","NewClubInfoLayer")
end

function NewClubInfoLayer:onExit()
    EventMgr:unregistListener(EventType.RET_GET_CLUB_TABLE,self,self.RET_GET_CLUB_TABLE)
    EventMgr:unregistListener(EventType.RET_REFRESH_CLUB,self,self.RET_REFRESH_CLUB)
    EventMgr:unregistListener(EventType.RET_ADD_CLUB_TABLE,self,self.RET_ADD_CLUB_TABLE)
    EventMgr:unregistListener(EventType.RET_UPDATE_CLUB_TABLE,self,self.RET_UPDATE_CLUB_TABLE)
    EventMgr:unregistListener(EventType.RET_DEL_CLUB_TABLE,self,self.RET_DEL_CLUB_TABLE)
    EventMgr:unregistListener(EventType.RET_UPDATE_CLUB_INFO,self,self.RET_UPDATE_CLUB_INFO)
    EventMgr:unregistListener(EventType.RET_DELED_CLUB,self,self.RET_DELED_CLUB)
    EventMgr:unregistListener(EventType.RET_CLUB_CHECK_LIST,self,self.RET_CLUB_CHECK_LIST)
    EventMgr:unregistListener(EventType.SUB_CL_LOGON_SUCCESS,self,self.SUB_CL_LOGON_SUCCESS)
    EventMgr:unregistListener(EventType.EVENT_TYPE_DID_ENTER_BACKGROUND,self,self.EVENT_TYPE_DID_ENTER_BACKGROUND)
    EventMgr:unregistListener(EventType.EVENT_TYPE_WILL_ENTER_FOREGROUND,self,self.EVENT_TYPE_WILL_ENTER_FOREGROUND)
    EventMgr:unregistListener(EventType.RET_GET_CLUB_LIST,self,self.RET_GET_CLUB_LIST)
    EventMgr:unregistListener(EventType.RET_GET_CLUB_LIST_FAIL,self,self.RET_GET_CLUB_LIST_FAIL)
    EventMgr:unregistListener(EventType.RET_ADDED_CLUB,self,self.RET_ADDED_CLUB)
    EventMgr:unregistListener(EventType.RET_UPDATE_CLUB_ROOMCARD,self,self.RET_UPDATE_CLUB_ROOMCARD)
    EventMgr:unregistListener(EventType.RET_REFRESH_CLUB_PLAY,self,self.RET_REFRESH_CLUB_PLAY)
    EventMgr:unregistListener(EventType.RET_REFRESH_CLUB_PLAY_FINISH,self,self.RET_REFRESH_CLUB_PLAY_FINISH)
    EventMgr:unregistListener(EventType.RET_UPDATE_CLUB_PLAYER_INFO ,self,self.RET_UPDATE_CLUB_PLAYER_INFO)
    EventMgr:unregistListener(EventType.RET_SETTINGS_CLUB_MEMBER ,self,self.RET_SETTINGS_CLUB_MEMBER)
    EventMgr:unregistListener(EventType.SUB_CL_USER_INFO ,self,self.SUB_CL_USER_INFO)
    EventMgr:unregistListener(EventType.RET_SETTINGS_CONFIG ,self,self.RET_SETTINGS_CONFIG)
    EventMgr:unregistListener(EventType.RET_CLUB_CHAT_GET_UNREAD_MSG, self, self.RET_CLUB_CHAT_GET_UNREAD_MSG)
    EventMgr:unregistListener(EventType.REFRESH_CLUB_BG, self, self.REFRESH_CLUB_BG)
    EventMgr:unregistListener(EventType.RET_CLUB_SETTING_ANTI_MEMBER,self,self.RET_CLUB_SETTING_ANTI_MEMBER)
    if self.clubData ~= nil then
        UserData.Guild:removeCloseClub(self.clubData.dwClubID)
        cc.UserDefault:getInstance():setIntegerForKey("UserDefault_NewClubID", self.clubData.dwClubID)
    end
    --self.Button_tblItem:release()
    self.Button_item:release()
end

function NewClubInfoLayer:refreshCeil(index, ceil)
	local items = ceil:getChildren()
	local selectTable = cc.UserDefault:getInstance():getIntegerForKey('CurSelClubTable', 1)
	for i,item in ipairs(items) do
		local data = self.tempTableViewCache[index*2 + i]
		if not data then
			item:setVisible(false)
			break
		end
		item:setVisible(true)
		if data.type == 0 then
			local childnodes = item:getChildren()
			for _,v in ipairs(childnodes) do
				v:setVisible(false)
			end
			local path = 'kwxclub/table/t_item.png'
			item:loadTextures(path,path,path)
			item:setPressedActionEnabled(true)
			item:addClickEventListener(function(sender)
				if self.isTableViewScrolling then
					return
				end
				Common:palyButton()
				self:addChild(require("app.MyApp"):create(self.clubData, self.allTableData):createView("NewClubSetPlaywayLayer"))
			end)
		elseif data.type == 1 then
			-- 玩法桌子
			local playwayIdx = data.playwayIdx
			local parameter = self.clubData.tableParameter[playwayIdx]
			local playerNum = parameter.bPlayerCount
			local childnodes = item:getChildren()
			for _,v in ipairs(childnodes) do
				v:setVisible(false)
			end

			local gameinfo = StaticData.Games[data.data.wKindID]
			local path = ''
			if playerNum > 4 then
				if selectTable == 1 then
					path = 'kwxclub/table/t_s_1.png'
				else
					path = 'kwxclub/table/t_s_2.png'
				end
			else
				if selectTable == 1 then
					path = string.format('kwxclub/table/b%d%d.png', gameinfo.clubtype, playerNum-1)
				else
					path = string.format('kwxclub/table/c%d%d.png', gameinfo.clubtype, playerNum-1)
				end
			end
			item:loadTextures(path,path,path)
			
			local uiText_wayName = ccui.Helper:seekWidgetByName(item,"Text_wayName")
			uiText_wayName:setVisible(true)
			uiText_wayName:enableOutline(cc.c4b(0, 29, 255), 1)
			if self.clubData.szParameterName[playwayIdx] ~= "" and self.clubData.szParameterName[playwayIdx] ~= " " then
				uiText_wayName:setString(self.clubData.szParameterName[playwayIdx])
			else
				local kindid = self.clubData.wKindID[playwayIdx]
				uiText_wayName:setString(StaticData.Games[kindid].name)
			end

			local uiText_turnNum = ccui.Helper:seekWidgetByName(item,"Text_turnNum")
			uiText_turnNum:setColor(cc.c3b(208, 179, 100))
			uiText_turnNum:enableOutline(cc.c4b(105, 91, 91), 1)
			uiText_turnNum:setVisible(true)
			local jushu = self.clubData.wGameCount[playwayIdx]
			uiText_turnNum:setString(jushu .. '局')

			item:setPressedActionEnabled(true)
			item:addClickEventListener(function(sender)
				if self.isTableViewScrolling then
					return
				end

				Common:palyButton()
				local isDisableCB = function()
					if not (Bit:_and(0x01, self.clubData.bIsDisable) == 0x01) then
						cc.UserDefault:getInstance():setIntegerForKey('club_quick_game_playwayid', self.clubData.dwPlayID[playwayIdx])
						require("common.SceneMgr"):switchTips(require("app.MyApp"):create(-2,self.clubData.dwPlayID[playwayIdx],data.data.wKindID,jushu,self.clubData.dwClubID,parameter,self:getEnterTableFigueValue(playwayIdx)):createView("InterfaceCreateRoomNode"))
					else
						require("common.MsgBoxLayer"):create(0,nil,'亲友圈打烊中')
					end
				end
				require("app.MyApp"):create(function() 
					performWithDelay(self, isDisableCB, 0.1)
				end):createView("InterfaceCheckRoomNode") 
			end)
			
		elseif data.type == 2 then
			local tempData = data.data
			local playerNum = tempData.tableParameter.bPlayerCount
			local childnodes = item:getChildren()
			for _,v in ipairs(childnodes) do
				v:setVisible(false)
			end

			local path = ''
			if playerNum > 4 then
				if selectTable == 1 then
					path = 'kwxclub/table/t_s_1.png'
				else
					path = 'kwxclub/table/t_s_2.png'
				end
			else
				if selectTable == 1 then
					path = string.format('kwxclub/table/b%d%d.png', StaticData.Games[tempData.wKindID].clubtype, playerNum-1)
				else
					path = string.format('kwxclub/table/c%d%d.png', StaticData.Games[tempData.wKindID].clubtype, playerNum-1)
				end
			end
			item:loadTextures(path,path,path)

			local uiText_wayName = ccui.Helper:seekWidgetByName(item,"Text_wayName")
			uiText_wayName:setVisible(true)
			uiText_wayName:enableOutline(cc.c4b(0, 29, 255), 1)
			local idx = self:getMoreTableIndex(tempData.wTableSubType)
			if idx then
				if self.clubData.szParameterName[idx] ~= "" and self.clubData.szParameterName[idx] ~= " " then
					uiText_wayName:setString(self.clubData.szParameterName[idx])
				else
					uiText_wayName:setString(StaticData.Games[tempData.wKindID].name)
				end
			else
				uiText_wayName:setString(StaticData.Games[tempData.wKindID].name)
			end
			
			local uiText_turnNum = ccui.Helper:seekWidgetByName(item,"Text_turnNum")
			uiText_turnNum:setVisible(true)
			uiText_turnNum:setColor(cc.c3b(208, 179, 100))
			uiText_turnNum:enableOutline(cc.c4b(105, 91, 91), 1)
			uiText_turnNum:setString(tempData.wCurrentGameCount .. '/' .. tempData.wGameCount)

			local itemNode = nil
			if playerNum <= 4 then
				itemNode = ccui.Helper:seekWidgetByName(item,"Panel_normal")
			else
				itemNode = ccui.Helper:seekWidgetByName(item,"Panel_tbl" .. playerNum)
			end
			itemNode:setVisible(true)
			local arrs = itemNode:getChildren()
			for _,v in ipairs(arrs) do
				v:setVisible(false)
			end

			if playerNum == 2 then
				local tableIndex = {1,3}
				for i, var in pairs(tableIndex) do
					local uiPanel_head = ccui.Helper:seekWidgetByName(itemNode,string.format("Panel_head%d",var))
					uiPanel_head:setVisible(false)
					if i <= tempData.wChairCount and tempData.dwUserID[i] ~= 0 then
						local uiImage_avatar = ccui.Helper:seekWidgetByName(uiPanel_head,"Image_avatar")
						local uiText_playerName = ccui.Helper:seekWidgetByName(uiPanel_head,"Text_playerName")
						Common:requestUserAvatar(tempData.dwUserID[i],tempData.szLogoInfo[i],uiImage_avatar,"clip")
						uiText_playerName:setString(Common:getShortName(tempData.szNickName[i], 8, 8))
						uiPanel_head:setVisible(true)
					end
				end
			else
				for i = 1, playerNum do
					local uiPanel_head = ccui.Helper:seekWidgetByName(itemNode,string.format("Panel_head%d",i))
					uiPanel_head:setVisible(false)
					if i <= tempData.wChairCount and tempData.dwUserID[i] ~= 0 then
						local uiImage_avatar = ccui.Helper:seekWidgetByName(uiPanel_head,"Image_avatar")
						local uiText_playerName = ccui.Helper:seekWidgetByName(uiPanel_head,"Text_playerName")
						Common:requestUserAvatar(tempData.dwUserID[i],tempData.szLogoInfo[i],uiImage_avatar,"clip")
						uiText_playerName:setString(Common:getShortName(tempData.szNickName[i], 8, 8))
						uiPanel_head:setVisible(true)
					end
				end
			end

			item:setPressedActionEnabled(true)
			item:addClickEventListener(function(sender)
				if self.isTableViewScrolling then
					return
				end

				Common:palyButton()
				local isAdmin = false
				if UserData.User.userID == self.clubData.dwUserID then
					isAdmin = true
				end
				if self:isAdmin(UserData.User.userID) then
					isAdmin = true
				end

				if (CHANNEL_ID == 10 or CHANNEL_ID == 11) and not isAdmin then
					cc.UserDefault:getInstance():setIntegerForKey('club_quick_game_playwayid', tempData.wTableSubType)
					require("common.SceneMgr"):switchTips(require("app.MyApp"):create(tempData.dwTableID,self:getEnterTableFigueValue(idx)):createView("InterfaceJoinRoomNode"))
					return
				end
				require("app.MyApp"):create(function()
					local isDisableCB = function()
						if Bit:_and(0x01, self.clubData.bIsDisable) == 0x01 then
							require("common.MsgBoxLayer"):create(0,nil,'亲友圈打烊中')
							return
						end
						self:addChild(require("app.MyApp"):create(tempData, isAdmin, self:getEnterTableFigueValue(idx)):createView("ClubTableLayer")) 
					end
					performWithDelay(self, isDisableCB, 0.1)
				end):createView("InterfaceCheckRoomNode")
			end)
		end
	end
end

function NewClubInfoLayer:_itemUpdateCall(index, ceil)
	if not ceil then
		ceil = ccui.Layout:create()
		ceil:setContentSize(CellSize)
		for i=1,2 do
			local item = self.Button_tblItem:clone()
			ceil:addChild(item)
			item:setPosition(150, 345 - (i - 1) * 240)
			item:setSwallowTouches(false)
		end
	end
	self:refreshCeil(index, ceil)
	return ceil
end

function NewClubInfoLayer:getDataCount()
	return math.ceil(self.tableViewLength / 2)
end

-- 获取桌子显示方式数量
function NewClubInfoLayer:getTableShowTypeNum()
	self.tempTableViewCache = clone(self.tableViewData) or {}

	if not self.clubData then
		return 0
	end

	if UserData.User.userID == self.clubData.dwUserID or self:isAdmin(UserData.User.userID) then
        return #self.tableViewData
    end

	local count = 0
	if Bit:_and(0x40, self.clubData.bIsDisable or 0) == 0x40 then
		for i,v in ipairs(self.tableViewData or {}) do
			if v.type == 2 then
				if v.data.bIsGameStart then
					-- 以开局
					count = count + 1
				end
			end
		end

		local fullPeopleNum = math.floor(count * (1 - 0.2)) --只显示20%的以开局桌子数
		local removeCount = 0
		for i=#self.tempTableViewCache,1,-1 do
			local v = self.tempTableViewCache[i]
			if v.type == 2 then
				local isSelfExist = false
				for _,v in ipairs(v.data.dwUserID or {}) do
					if v ~= 0 then
						if v == UserData.User.userID then
							isSelfExist = true
						end
					end
				end
				
				if v.data.bIsGameStart and not isSelfExist then
					-- 以开局
					table.remove(self.tempTableViewCache, i)
					removeCount = removeCount + 1
					if removeCount >= fullPeopleNum then
						break
					end
				end
			end
		end
		count = #self.tableViewData - fullPeopleNum
	else
		count = #self.tableViewData
	end
	return count
end

function NewClubInfoLayer:onCreate(param)
    self.clubData = param[1]
	self.Chat = UserData.Chat -- 俱乐部聊天信息
	
	--牌桌tableview
	self.tableViewData = {}
	self.tempTableViewCache = {}
	self.isTableViewScrolling = false
	local viewSize = cc.size(self.Panel_bg:getContentSize().width, 480)
	self.listView = Common:_createList(viewSize, handler(self, self._itemUpdateCall), CellSize.width, CellSize.height, handler(self, self.getDataCount), nil, cc.SCROLLVIEW_DIRECTION_HORIZONTAL, nil, false)
	self.listView:setPosition(cc.p(0,136))
	self.Node_tableView:addChild(self.listView)
	self.listView:registerScriptHandler(function(view)
		self.isTableViewScrolling = view:isDragging()
	end ,cc.SCROLLVIEW_SCRIPT_SCROLL)
	schedule(self.listView, function() 
		if self.isTableViewRefresh then
			self.isTableViewRefresh = false
			local offset = self.listView:getContentOffset()
			self.tableViewLength = self:getTableShowTypeNum()
			self.listView:reloadData()
			self.listView:setContentOffset(cc.p(offset.x, offset.y))
		end
	end, 0.5)

    self.Button_mp:setVisible(true)
    self.Panel_bg:setVisible(false)
    self.Panel_ui:setVisible(false)
    self.Image_checkRedPoint:setVisible(false)
    self.Image_chatRedPoint:setVisible(false)
    self.Image_playWayInfo:setVisible(false)
    self.Image_noSetWayFlag:setVisible(false)
    self.Text_lastRecordName:setVisible(false)
    self.Button_mem:setVisible(false)
    self.Button_give:setVisible(false)
    self.Button_notice:setVisible(false)
    self.Button_partner:setVisible(false)
    self.Button_share:setVisible(false)
    --self.Button_tblItem:retain()
    self.Button_item:retain()
    self.ListView_more:removeAllChildren()
    local callback = function()
        self:onMoreClub()
    end
    Common:registerScriptMask(self.Image_moreClubFrame, callback)

    local callback2 = function()
        self.Panel_mp:setVisible(false)
        self.Image_mpFrame:setVisible(false)
    end
    Common:registerScriptMask(self.Image_mpFrame, callback2)

    if self.clubData == nil then
        local dwClubID = cc.UserDefault:getInstance():getIntegerForKey("UserDefault_NewClubID", 0)
        if dwClubID ~= 0 then
            UserData.Guild:refreshClub(dwClubID)
        else
            self.ListView_more:removeAllChildren()
            UserData.Guild:getClubList()
        end
    else
        cc.UserDefault:getInstance():setIntegerForKey("UserDefault_NewClubID", self.clubData.dwClubID)
        UserData.Guild:refreshClub(self.clubData.dwClubID)
        UserData.Guild:saveLastUseClubRecord(self.clubData.dwClubID)
    end
    self:ReqRecordMsg()
    
    local canGo = cc.UserDefault:getInstance():getIntegerForKey("club_record_go",0)
    if canGo == 1 then
        local clubData = {}
        clubData.dwUserID = cc.UserDefault:getInstance():getIntegerForKey("club_dwUserID",0)
        clubData.dwClubID = cc.UserDefault:getInstance():getIntegerForKey("club_dwClubID",0)
        clubData.szClubName = cc.UserDefault:getInstance():getStringForKey("club_ClubName",'')
        local isAdmin = cc.UserDefault:getInstance():getBoolForKey('club_isAdmin',false)
        local box = require("app.MyApp"):create(clubData,isAdmin):createView('NewClubRecord')
        self:addChild(box)
    end

    local selectBg = cc.UserDefault:getInstance():getIntegerForKey('CurSelClubBg', 4)
    self.Image_bg:loadTexture(string.format('kwxclub/table/t_%d.jpg', selectBg))
    self.Text_yuanbaoNum:setString(string.format("%d",UserData.Bag:getBagPropCount(1009)))

    local isShow = cc.UserDefault:getInstance():getBoolForKey('club_isallshow', true)
    if not isShow then
        local path = 'kwxclub/club_hall_5.png'
        self.Button_isShow:loadTextures(path, path, path)
        self.Panel_topRight:setVisible(false)
        self.Image_bottom:setVisible(false)
    end

    self.Button_ybFrame:setVisible(false)
    self.Button_fatigue:setVisible(false)
    self.Button_give:setVisible(false)
    self.Image_moneyIcon:setVisible(false)
    self.Image_lAntiValue:setVisible(false)
end

function NewClubInfoLayer:onReturn()
    cc.UserDefault:getInstance():setStringForKey("UserDefault_Operation","")
    self:removeFromParent()
end

function NewClubInfoLayer:onShare()
    if CHANNEL_ID == 10 or CHANNEL_ID == 11 then
        local node = require("app.MyApp"):create(self.clubData):createView("NewClubParnterAddMemLayer")
        self:addChild(node)
    else
        local data = clone(UserData.Share.tableShareParameter[2])
        if not data then
            return
        end
        data.szShareTitle = string.format("亲友圈昵称:%s(亲友圈ID:%d)",self.clubData.szClubName,self.clubData.dwClubID)
        data.szShareContent = "好友邀请您加入亲友圈畅玩游戏,自动开房,点击加入>>>"
        data.szShareUrl = string.format(data.szShareUrl,self.clubData.dwClubID, UserData.User.userID)
        require("app.MyApp"):create(data):createView("ShareLayer")
    end
end

function NewClubInfoLayer:onMingPian()
    UserData.User:sendMsgUpdateUserInfo(1)
    Common:requestErWeiMaPicture(UserData.User.szErWeiMaLogo, self.Image_mp)
    self.Panel_mp:setVisible(true)
    self.Image_mpFrame:setVisible(true)
end

function NewClubInfoLayer:onModifyMp()
    local data = clone(UserData.Share.tableShareParameter[10])
    if not data then
        return
    end
    data.szShareUrl = string.format(data.szShareUrl,UserData.User.userID)
    require("app.MyApp"):create(data):createView("ShareLayer")
    self.Panel_mp:setVisible(false)
    self.Image_mpFrame:setVisible(false)
end

function NewClubInfoLayer:onMember()
    self:addChild(require("app.MyApp"):create(self.clubData, self.userOffice):createView("NewClubMemLayer"))
end

function NewClubInfoLayer:onStatistics()
    local isAdmin = false
    --群主和管理员都有权限
    if UserData.User.userID == self.clubData.dwUserID or self:isAdmin(UserData.User.userID)  then
        isAdmin = true
    end
    cc.UserDefault:getInstance():setStringForKey("club_ClubName",self.clubData.szClubName)
    cc.UserDefault:getInstance():setIntegerForKey("club_dwUserID",self.clubData.dwUserID)
    cc.UserDefault:getInstance():setIntegerForKey("club_dwClubID",self.clubData.dwClubID)
    cc.UserDefault:getInstance():setBoolForKey('club_isAdmin',isAdmin)
    local box = require("app.MyApp"):create(self.clubData,isAdmin):createView('NewClubRecord')
    self:addChild(box)
end

function NewClubInfoLayer:onManager()
    self:addChild(require("app.MyApp"):create(self.clubData):createView("NewClubSettingLayer"))
end

-- function NewClubInfoLayer:onChat()
--     if not self.clubData then
--         return
--     end
--     self.Image_chatRedPoint:setVisible(false)
--     local box = require("app.MyApp"):create(self.clubData):createView('GroupLayer')
--     self:addChild(box)
-- end

function NewClubInfoLayer:onQuickStart()
    local waynum, retIndex = self:getPlayWayNums()
    local tables = self.tableViewData
    if waynum == 0 then
        require("common.MsgBoxLayer"):create(0,nil,'请添加玩法')
        return
    end

    local isDisableCB = function()
        if Bit:_and(0x01, self.clubData.bIsDisable) == 0x01 then
            require("common.MsgBoxLayer"):create(0,nil,'亲友圈打烊中')
            return
        end

        local recordId = cc.UserDefault:getInstance():getIntegerForKey('club_quick_game_playwayid', 0)
        print('上次玩法ID:', recordId)
        if recordId == 0 then
            local playwayid = self.clubData.dwPlayID[retIndex[1]]
            cc.UserDefault:getInstance():setIntegerForKey('club_quick_game_playwayid', playwayid)
            for i,v in ipairs(tables) do
                if v.data and v.data.dwTableID and v.data.wTableSubType == playwayid then
                    local data = v.data
                    local wKindID = math.floor(data.dwTableID/10000)
                    if (wKindID == 51 or wKindID == 53 or wKindID == 55 or wKindID == 56 or wKindID == 57 or wKindID == 58 or wKindID == 59) and data.tableParameter.bCanPlayingJoin == 1 and data.wCurrentChairCount < data.wChairCount  then
                        require("common.SceneMgr"):switchTips(require("app.MyApp"):create(data.dwTableID,self:getEnterTableFigueValue(1)):createView("InterfaceJoinRoomNode"))
                        return
                    elseif data.bIsGameStart == false and data.wCurrentChairCount < data.wChairCount then
                        require("common.SceneMgr"):switchTips(require("app.MyApp"):create(data.dwTableID,self:getEnterTableFigueValue(1)):createView("InterfaceJoinRoomNode"))
                        return
                    end
                end
            end
            require("common.SceneMgr"):switchTips(require("app.MyApp"):create(-2,playwayid,self.clubData.wKindID[retIndex[1]],self.clubData.wGameCount[retIndex[1]],self.clubData.dwClubID,self.clubData.tableParameter[retIndex[1]],self:getEnterTableFigueValue(retIndex[1])):createView("InterfaceCreateRoomNode"))
        
        else
            for i,v in ipairs(tables) do
                if v.data and v.data.dwTableID and v.data.wTableSubType == recordId then
                    local data = v.data
                    local wKindID = math.floor(data.dwTableID/10000)
                    if (wKindID == 51 or wKindID == 53 or wKindID == 55 or wKindID == 56 or wKindID == 57 or wKindID == 58 or wKindID == 59) and data.tableParameter.bCanPlayingJoin == 1 and data.wCurrentChairCount < data.wChairCount  then
                        require("common.SceneMgr"):switchTips(require("app.MyApp"):create(data.dwTableID,self:getEnterTableFigueValue(1)):createView("InterfaceJoinRoomNode"))
                        return
                    elseif data.bIsGameStart == false and data.wCurrentChairCount < data.wChairCount then
                        require("common.SceneMgr"):switchTips(require("app.MyApp"):create(data.dwTableID,self:getEnterTableFigueValue(1)):createView("InterfaceJoinRoomNode"))
                        return
                    end
                end
            end

            for i,v in ipairs(tables) do
                if v.data and v.data.wTableSubType then
                    local idx = self:getClubDataIndex(v.data.wTableSubType)
                    if recordId == v.data.wTableSubType then
                        require("common.SceneMgr"):switchTips(require("app.MyApp"):create(-2,recordId,v.data.wKindID,self.clubData.wGameCount[idx],self.clubData.dwClubID,self.clubData.tableParameter[idx],self:getEnterTableFigueValue(idx)):createView("InterfaceCreateRoomNode"))
                        return
                    end
                end
            end
            require("common.MsgBoxLayer"):create(0,nil,"上次玩法不存在!")
        end
    end

    require("app.MyApp"):create(function() 
        performWithDelay(self, isDisableCB, 0.1)
    end):createView("InterfaceCheckRoomNode") 
end

function NewClubInfoLayer:getClubDataIndex(dwPlayID)
    for i,v in ipairs(self.clubData.dwPlayID or {}) do
        if dwPlayID == v then
            return i
        end
    end
    return nil
end

function NewClubInfoLayer:onCustomRoom()
    if self:getPlayWayNums() <= 0 then
        require("common.MsgBoxLayer"):create(0,nil,'该亲友圈未设置玩法')
        return
    end

    require("app.MyApp"):create(function() 
        local isDisableCB = function()
            if Bit:_and(0x01, self.clubData.bIsDisable) == 0x01 then
                require("common.MsgBoxLayer"):create(0,nil,'亲友圈打烊中')
                return
            end
            self:addChild(require("app.MyApp"):create(self.clubData.wKindID,2,self.clubData.dwClubID):createView("RoomCreateLayer"))
        end
        performWithDelay(self, isDisableCB, 0.1)
    end):createView("InterfaceCheckRoomNode")
end

function NewClubInfoLayer:onMoreClub()
    local size = self.Panel_bg:getContentSize()
    if self.Image_moreClubFrame:isVisible() then
        self.Button_moreClub:stopAllActions()
        local moveto = cc.MoveTo:create(0.2, cc.p(size.width, size.height / 2))
        local callfunc = cc.CallFunc:create(function()
            self.Image_moreClubFrame:setVisible(false)
        end)
        self.Button_moreClub:runAction(cc.Sequence:create(moveto, callfunc))
    else
        self.Image_moreClubFrame:setVisible(true)
        self.ListView_more:setVisible(false)
        self.Button_moreClub:setPositionX(size.width)
        self.Button_moreClub:stopAllActions()
        local moveto = cc.MoveTo:create(0.2, cc.p(size.width - 440, size.height / 2))
        local callfunc = cc.CallFunc:create(function()
            self.ListView_more:setVisible(true)
            self.ListView_more:removeAllChildren()
            UserData.Guild:getClubList()
        end)
        self.Button_moreClub:runAction(cc.Sequence:create(moveto, callfunc))

        local box = self.Image_bottom:getChildByName('NewClubMorePlaywayLayer')
        if box then
            if box.Image_PWFrame:isVisible() then
                box:onAllPWBtn()
            end
        end
    end
end

function NewClubInfoLayer:onCreateClub( ... )
    self:addChild(require("app.MyApp"):create(1):createView("NewClubLayer"))
end

function NewClubInfoLayer:onJoinClub( ... )
    self:addChild(require("app.MyApp"):create(2):createView("NewClubLayer"))
end

function NewClubInfoLayer:onPlayWay()
    if self.clubData.dwUserID == UserData.User.userID or self:isAdmin(UserData.User.userID) then
        self:addChild(require("app.MyApp"):create(self.clubData):createView("NewClubSetPlaywayLayer"))
    else
        self:addChild(require("app.MyApp"):create(self.clubData, self.allTableData):createView("NewClubSetPlaywayLayer"))
    end
end

function NewClubInfoLayer:onShareChat()
    local data = clone(UserData.Share.tableShareParameter[9])
    if not data then
        return
    end
    data.szShareTitle = string.format(data.szShareTitle, self.clubData.szClubName)
    data.szShareContent = string.format("亲友圈ID：%d  群主：%s，点击进入聊天室", self.clubData.dwClubID, self.clubData.szNickName)
    local szParameter = string.format("{\"app_id\":%d,\"id\":%d,\"CT\":%d}", 10068, self.clubData.dwClubID, StaticData.Channels[CHANNEL_ID].ChannelType)
    szParameter = Base64.encode(szParameter)
    data.szShareUrl = string.format(data.szShareUrl,szParameter)
    require("app.MyApp"):create(data):createView("ShareLayer")
end

function NewClubInfoLayer:onPartner()
    self:addChild(require("app.MyApp"):create(self.clubData):createView("NewClubPartnerLayer"))
end

function NewClubInfoLayer:onGive()
    self:addChild(require("app.MyApp"):create(self.clubData):createView("NewClubSellFatigueLayer"))
end

function NewClubInfoLayer:onNotice()
    local isRedPoint = self.Image_checkRedPoint:isVisible()
    self:addChild(require("app.MyApp"):create(self.clubData, isRedPoint):createView("NewClubNoticeLayer"))
end

function NewClubInfoLayer:onFatigue()
    if self.clubData.dwClubID == 359949 or self.clubData.dwClubID == 807113 or self.clubData.dwClubID == 110852 or self.clubData.dwClubID == 460861 then
        self:addChild(require("app.MyApp"):create(self.clubData):createView("NewClubDefendLayer"))
    else
        self:addChild(require("app.MyApp"):create(self.clubData, self.userFatigueValue, self.userOffice):createView("NewClubFatigueLayer"))
    end
end

function NewClubInfoLayer:onIsSHow()
    if self.Panel_topRight:isVisible() then
        local path = 'kwxclub/club_hall_5.png'
        self.Button_isShow:loadTextures(path, path, path)
        self.Panel_topRight:setVisible(false)
        self.Image_bottom:setVisible(false)
        cc.UserDefault:getInstance():setBoolForKey('club_isallshow',false)
    else
        local path = 'kwxclub/club_hall_4.png'
        self.Button_isShow:loadTextures(path, path, path)
        self.Panel_topRight:setVisible(true)
        self.Image_bottom:setVisible(true)
        cc.UserDefault:getInstance():setBoolForKey('club_isallshow',true)
    end
end

function NewClubInfoLayer:onZJShare()
    local data = clone(UserData.Share.tableShareParameter[11])
    require("app.MyApp"):create(data):createView("ShareLayer")  
end

function NewClubInfoLayer:onAddYB()
    local data = clone(UserData.Share.tableShareParameter[12])
    dump(data, '购买元宝：')
    require("app.MyApp"):create(data):createView("ShareLayer") 
end

function NewClubInfoLayer:onTempClose()
    self.Panel_tempNotice:setVisible(false)
end

------------------------------------------------------------------------

function NewClubInfoLayer:createClubTable(playwayId)
	self.tableViewData = {}
	self.tempTableViewCache = {}
    playwayId = playwayId or 0
    cc.UserDefault:getInstance():setIntegerForKey('CurSelPlaywayId', playwayId)

    --空桌在后排版最前面插入快捷桌子
    local sortTable = cc.UserDefault:getInstance():getBoolForKey("Select_SortTable_Left", false)
    local index = 0
    if not sortTable then
		index = 1
		StaticData.Games[0] = StaticData.Games[0] or {}
		StaticData.Games[0].clubtype = 0
		table.insert(self.tableViewData, {
			type = 0, 
			data = {wKindID = 0}
		})
    end

    -- 创建玩法桌子
    local curGameId = cc.UserDefault:getInstance():getIntegerForKey('CurSelGameID', 0)
    for i,v in ipairs(self.clubData.wKindID) do
        local gameinfo = StaticData.Games[v]
        local IsShowKey = 'IsShowGame' .. v
        local isShow = cc.UserDefault:getInstance():getBoolForKey(IsShowKey,true)
        if v ~= 0 and gameinfo and isShow and (curGameId == 0 or curGameId == v) and (playwayId == 0 or playwayId == self.clubData.dwPlayID[i]) then
			index = index + 1
			local row = index % 2
            if row == 0 then
                row = 2
            end
            local col = math.ceil(index / 2)
            local pos = (col - 1) * 2 + row
			table.insert(self.tableViewData, {
				type = 1, 
				playwayIdx = i,
				data = {pos = pos, wKindID = v, wTableSubType = self.clubData.dwPlayID[i]}
			})
        end
	end

	-- 设置玩法桌子位置
    local function comp(v1, v2)
        if StaticData.Games[v1.data.wKindID].clubtype < StaticData.Games[v2.data.wKindID].clubtype then
            return true
        else
            return false
        end
    end
    table.sort(self.tableViewData, comp)
    for i,v in ipairs(self.tableViewData) do
        local row = i % 2
        if row == 0 then
            row = 2
        end
        local col = math.ceil(i / 2)
        v.data.pos = (col - 1) * 2 + row
	end
	--self.tableViewLength = #self.tableViewData
	--self.listView:reloadData()
	self.listView:setContentOffset(cc.p(0, 0))
	self.isTableViewRefresh = true
	UserData.Guild:getClubTable(self.clubData.dwClubID)
end

--是否是管理员
function NewClubInfoLayer:isAdmin(userid, adminData)
    adminData = adminData or self.clubData.dwAdministratorID
    for i,v in ipairs(adminData or {}) do
        if v == userid then
            return true
        end
    end
    return false
end

--刷新亲友圈
function NewClubInfoLayer:updateClubInfo()
    if not self.clubData.bIsDisable then
        return
    end

    self.Panel_bg:setVisible(true)
    self.Panel_ui:setVisible(true)
    self.Image_playWayInfo:setVisible(false)
    self.Image_checkRedPoint:setVisible(false)  
    self.Image_chatRedPoint:setVisible(false)
    UserData.Guild:addEnterClub(self.clubData.dwClubID)
    self.Text_clubName:setString(self.clubData.szClubName)
    self.Text_clubID:setString("圈ID:" .. self.clubData.dwClubID)

    if UserData.User.userID == self.clubData.dwUserID or self:isAdmin(UserData.User.userID)  then
        self.Text_clubPeople:setString(self.clubData.dwOnlinePlayerCount .. '/' .. self.clubData.dwClubPlayerCount)
    else
        if Bit:_and(0x04, self.clubData.bIsDisable) == 0x04 then
            self.Text_clubPeople:setString(self.clubData.dwOnlinePlayerCount .. '/' .. self.clubData.dwClubPlayerCount)
        else
            self.Text_clubPeople:setString('99+/999+')
        end
    end

    self.Button_custom:setVisible(self.clubData.bHaveCustomizeRoom)
    if self.clubData.dwUserID ~= UserData.User.userID and not self:isAdmin(UserData.User.userID) then
    else
        UserData.Guild:getClubCheckList(self.clubData.dwClubID)
        UserData.Guild:getClubCardInfo(self.clubData.dwClubID)
    end

    if self.clubData.cbPlayCount > 0 then
        self.Image_noSetWayFlag:setVisible(false)
        self.listView:setVisible(true)
    else
        self.listView:setVisible(false)
        self.Image_noSetWayFlag:setVisible(true)
    end

    --广播
    if not self.clubData.szAnnouncement or self.clubData.szAnnouncement == "" or self.clubData.szAnnouncement == " " then
        self:playBroadcast('欢迎加入亲友圈，祝大家生活愉快')
    else
        self:playBroadcast(self.clubData.szAnnouncement)
    end

    if not (UserData.User.userID == self.clubData.dwUserID or self:isAdmin(UserData.User.userID)) then
        if Bit:_and(0x08, self.clubData.bIsDisable) == 0x08 then
            self.Button_give:setVisible(true)
        else
            self.Button_give:setVisible(false)
        end
    else
        self.Button_give:setVisible(true)
    end

    --只有这4个亲友圈保留防沉迷
    if self.clubData.dwClubID == 359949 or self.clubData.dwClubID == 807113 or self.clubData.dwClubID == 110852 or self.clubData.dwClubID == 460861 then  --CHANNEL_ID == 26 or CHANNEL_ID == 27 then
        if Bit:_and(0x20, self.clubData.bIsDisable) == 0x20 then
            self.Button_fatigue:setVisible(true)
            local path = 'kwxclub/kwxclub_24.png'
            self.Button_fatigue:loadTextures(path, path, path)
        else
            self.Button_fatigue:setVisible(false)
        end
        self.Button_give:setVisible(false)
        self.Image_moneyIcon:setVisible(true)
        self.Image_moneyIcon:loadTexture('common/yuanbaoc_icon.png')
        self.Image_lAntiValue:setVisible(true)
    else
    	local path = 'kwxclub/club_info_6.png'
        self.Button_fatigue:setVisible(true)
        self.Button_fatigue:loadTextures(path, path, path)
        self.Button_give:setVisible(true)
        self.Image_moneyIcon:setVisible(true)
        self.Image_moneyIcon:loadTexture('kwxclub/club_hall_3.png')
        self.Image_lAntiValue:setVisible(false)
    end
end

--移除亲友圈桌子
function NewClubInfoLayer:removeClubTable(dwTableID)
	print('移除桌子:', dwTableID)
	self.isTableViewRefresh = true
    self.allTableData[dwTableID] = nil
    for i, v in ipairs(self.tableViewData) do
		if v.data and v.data.dwTableID == dwTableID then
			table.remove(self.tableViewData, i)
		
			local function comp(v1, v2)
				if v1.data.pos < v2.data.pos then
					return true
				else
					return false
				end
			end
			table.sort(self.tableViewData, comp)
			
			for i,v in ipairs(self.tableViewData) do
				local row = i % 2
				if row == 0 then
					row = 2
				end
				local col = math.ceil(i / 2)
				v.data.pos = (col - 1) * 2 + row
			end
            break
        end
	end
end

-- type 1 空桌在前  2 空桌在后
function NewClubInfoLayer:getTableSortIndex(data, itype)
    if not data then
        return 0
    end

    local num = 0
    for _,v in ipairs(data.dwUserID or {}) do
        if v ~= 0 then
            num = num + 1
        end
    end

    if num == 0 then
        -- 没人
        if itype == 1 then
            num = -1
        else
            if data.wKindID == 0 then
                num = -1
            else
                num = 9999
            end
        end
    else
        if num >= data.wChairCount then
            -- 满人
            num = 6666
        end
    end
    return num
end

--[[
1.没满人最前面
2.满人中间
3.没人最后
and
1.比较类型大小
]]
function NewClubInfoLayer:sortNewTable(dwTableID, itype)
    local function comp(v1, v2)
        if self:getTableSortIndex(v1.data, itype) < self:getTableSortIndex(v2.data, itype) or 
        (self:getTableSortIndex(v1.data, itype) <= self:getTableSortIndex(v2.data, itype) and StaticData.Games[v1.data.wKindID].clubtype < StaticData.Games[v2.data.wKindID].clubtype) then
            return true
        else
            return false
        end
    end
    table.sort(self.tableViewData, comp)

    for i,v in ipairs(self.tableViewData) do
        local row = i % 2
        if row == 0 then
            row = 2
        end
        local col = math.ceil(i / 2)
        v.data = v.data or {}
        v.data.pos = (col - 1) * 2 + row
    end
end

function NewClubInfoLayer:isExistData(data)
	for i,v in ipairs(self.tableViewData) do
		if v.data.dwTableID == data.dwTableID then
			local pos = self.tableViewData[i].data.pos
			data.pos = pos
			self.tableViewData[i].data = data
			return true
		end
	end
	return false
end

function NewClubInfoLayer:getCurrentTableCount()
	local count = 0
	for i,v in ipairs(self.tableViewData or {}) do
		if v.type == 2 then
			count = count + 1
		end
	end
	return count
end

--刷新某个桌子信息
function NewClubInfoLayer:refreshTableOneByOne(data)
	dump(data, '刷新桌子:')
	self.isTableViewRefresh = true
    self.allTableData[data.dwTableID] = data
    local curSelPlaywayId = cc.UserDefault:getInstance():getIntegerForKey('CurSelPlaywayId', 0)
    if curSelPlaywayId ~= 0 and curSelPlaywayId ~= data.wTableSubType then
        return
    end

    local curGameId = cc.UserDefault:getInstance():getIntegerForKey('CurSelGameID', 0)
    if curGameId ~= 0 and curGameId ~= data.wKindID then
        return
    end

    local IsShowKey = 'IsShowGame' .. data.wKindID
    local isShow = cc.UserDefault:getInstance():getBoolForKey(IsShowKey,true)
    if not isShow then
        return
    end
 
	local playerNum = data.tableParameter.bPlayerCount
    local isNewCreate = false
    if not self:isExistData(data) then
		isNewCreate = true
		data.pos = #self.tableViewData + 1
		table.insert(self.tableViewData, {
			type = 2, 
			data = data
		})
    end

    local sortTable = cc.UserDefault:getInstance():getBoolForKey("Select_SortTable_Left", false)
    if sortTable then
        -- 只刷新新创建桌子与玩家加入，局数刷新不刷位置
        if isNewCreate or data.wCurrentGameCount <= 0 then
			self:sortNewTable(data.dwTableID, 1)
        end
    else
        if isNewCreate or data.wCurrentGameCount <= 0 then
			self:sortNewTable(data.dwTableID, 2)
        end
	end
end

--广播
function NewClubInfoLayer:playBroadcast(notice)
    printInfo('playBroadcast:%s', notice)
    self.Text_broadcast:stopAllActions()
    self.Panel_broadcast:stopAllActions()
    local function showBroadcast()
        if not self.Panel_broadcast:isVisible() then
            self.Text_broadcast:setString(notice)
            self.Text_broadcast:setPositionX(self.Text_broadcast:getParent():getContentSize().width)
            local time = (self.Text_broadcast:getParent():getContentSize().width + self.Text_broadcast:getAutoRenderSize().width)/100
            self.Text_broadcast:runAction(cc.MoveTo:create(time,cc.p(-self.Text_broadcast:getAutoRenderSize().width,self.Text_broadcast:getPositionY())))
            self.Panel_broadcast:runAction(cc.Sequence:create(cc.DelayTime:create(time),cc.Hide:create(),cc.DelayTime:create(5),cc.CallFunc:create(showBroadcast)))
            self.Panel_broadcast:setVisible(true)
        else
            self.Panel_broadcast:setVisible(false)
            self.Panel_broadcast:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(showBroadcast)))
        end
    end
    showBroadcast()

    self.Text_tempNotice:setString(notice)
end

--添加一个亲友圈节点
function NewClubInfoLayer:addOnceClubItem(data)
    if type(data) ~= 'table' then
        printError('NewClubInfoLayer:addOnceClubItem data error')
        return
    end
    local item = self.Button_item:clone()
    item:setName('clubitem_' .. data.dwClubID)
    item.data = data
    local Image_selLight = self:seekWidgetByNameEx(item, "Image_selLight")
    local Image_leadHead = self:seekWidgetByNameEx(item, "Image_leadHead")
    local Text_leader    = self:seekWidgetByNameEx(item, "Text_leader")
    local Text_memNum    = self:seekWidgetByNameEx(item, "Text_memNum")
    local Text_playWay   = self:seekWidgetByNameEx(item, "Text_playWay")
    if self.clubData and data.dwClubID == self.clubData.dwClubID then
        Image_selLight:setVisible(true)
        self.lastSelLight = Image_selLight
        --self.ListView_more:insertCustomItem(item, 0)
    else
        Image_selLight:setVisible(false)
		--self.ListView_more:pushBackCustomItem(item)
    end
	
    local items = self.ListView_more:getItems()
    local isFound = false
    local tableFrontClubList = {}
    for key, var in pairs(UserData.Guild.tableLastUseClubRecord) do
    	if var == data.dwClubID then
    	    isFound = true
    	    break
    	end
        table.insert(tableFrontClubList,1,var)
    end
    if isFound == false then
        self.ListView_more:pushBackCustomItem(item)
    else
        local pos = 0
        local isFound = false
        for key, var in pairs(tableFrontClubList) do
            for k, v in pairs(items) do
        		local tempData = v.data
        		if tempData.dwClubID == var then
        		    pos = k
        		    isFound = true
        		    break
        		end
        	end
        	if isFound == true then
        	   break
        	end
        end
        self.ListView_more:insertCustomItem(item,pos)
    end
    Common:requestUserAvatar(data.dwUserID, data.szLogoInfo, Image_leadHead, "img")
    Text_leader:setColor(cc.c3b(114, 67, 13))
    Text_memNum:setColor(cc.c3b(114, 67, 13))
    Text_playWay:setColor(cc.c3b(114, 67, 13))
    Text_leader:setString(data.szClubName)
    Text_playWay:setString("圈ID:" .. data.dwClubID)

    if UserData.User.userID == data.dwUserID or self:isAdmin(UserData.User.userID)  then
        Text_memNum:setString("人数：" .. data.dwOnlinePlayerCount .. '/' .. data.dwClubPlayerCount)
    else
        if Bit:_and(0x04, data.bIsDisable) == 0x04 then
            Text_memNum:setString("人数：" .. data.dwOnlinePlayerCount .. '/' .. data.dwClubPlayerCount)
        else
            Text_memNum:setString("人数:99+/999+")
        end
    end

    self:setMemberMgrFlag(item, data)
    item:setTouchEnabled(true)
    item:addClickEventListener(function(sender)
        if self.lastSelLight then
            self.lastSelLight:setVisible(false)
        end
        Image_selLight:setVisible(true)
        self.lastSelLight = Image_selLight
        UserData.Guild:refreshClub(data.dwClubID)
    end)
    self.ListView_more:refreshView()
end

--设置成员不同权限标识
function NewClubInfoLayer:setMemberMgrFlag(item, data)
    if not item then
        return
    end
    data = data or {}
    local Image_adminIcon = self:seekWidgetByNameEx(item, "Image_adminIcon")
    if data.dwUserID == UserData.User.userID then
        Image_adminIcon:setVisible(true)
        Image_adminIcon:loadTexture('kwxclub/newclub_m22.png')
    elseif self:isAdmin(UserData.User.userID, data.dwAdministratorID) then
        Image_adminIcon:setVisible(true)
        Image_adminIcon:loadTexture('kwxclub/newclub_m21.png')
    else
        Image_adminIcon:setVisible(false)
    end
end

--刷新房卡信息
function NewClubInfoLayer:refreshRoomCardInfo(data)
    -- if type(data) ~= 'table' then
    --     printError('NewClubInfoLayer:refreshRoomCardInfo data error')
    --     return
    -- end
    -- local dwRoomCardCount = Common:itemNumberToString(data.dwRoomCardCount)
    -- self.Text_cardNum:setString(dwRoomCardCount .. '张')
    -- local dwSavingCount = Common:itemNumberToString(data.dwSavingCount)
    -- self.Text_freeNum:setString(dwSavingCount .. '张')
    -- self.Text_freeDes:setPositionX(0)

    -- self.Text_freeTime:stopAllActions()
    -- local time = data.dwDeadlineTime - UserData.Time:getServerTimer()  --os.time()
    -- local function update()
    --     time = data.dwDeadlineTime - UserData.Time:getServerTimer()
    --     if time <= 0 then
    --         time = 0
    --         self.Text_freeTime:stopAllActions()
    --     end
        
    --     local d = math.floor(time / 86400)
    --     local h = math.floor(time / 3600) % 24
    --     local m = math.floor(time / 60) % 60
    --     self.Text_freeTime:setString(string.format('%02d天 %02d小时 %02d分', d, h, m))
    -- end
    -- schedule(self.Text_freeTime, update, 1)
    -- update()
end

function NewClubInfoLayer:megerClubData(data)
    if type(data) ~= 'table' then
        return
    end
    self.clubData = self.clubData or {}
    for k,v in pairs(data) do
        self.clubData[k] = v
    end
end

function NewClubInfoLayer:getMoreTableIndex(wplayId)
    for i,v in ipairs(self.clubData.dwPlayID or {}) do
        if v == wplayId then
            return i
        end
    end
    return nil
end

function NewClubInfoLayer:getPlayWayNums()
    local retIndex = {}
    local curGameId = cc.UserDefault:getInstance():getIntegerForKey('CurSelGameID', 0)
    local curSelPlaywayId = cc.UserDefault:getInstance():getIntegerForKey('CurSelPlaywayId', 0)
    if curSelPlaywayId ~= 0 then
        for i,v in ipairs(self.clubData.dwPlayID or {}) do
            if curSelPlaywayId == v then
                table.insert(retIndex, i)
                break
            end
        end

        return 1, retIndex
    end

    local num = 0
    for i,v in ipairs(self.clubData.wKindID or {}) do
        local gameinfo = StaticData.Games[v]
        local IsShowKey = 'IsShowGame' .. v
        local isShow = cc.UserDefault:getInstance():getBoolForKey(IsShowKey,true)
        if gameinfo and isShow and (curGameId == 0 or curGameId == v) then
            num = num + 1
            table.insert(retIndex, i)
        end
    end
    return num, retIndex
end

--请求未读聊天信息
function NewClubInfoLayer:ReqRecordMsg()
    self.Chat:SendChatUnReadMsg()
end

function NewClubInfoLayer:getEnterTableFigueValue(curPlaywayIdx)
    local maxValue = 0
    local idx = curPlaywayIdx
    if idx then
        for k,v in pairs(self.clubData.dwPayCount[idx]) do
            if maxValue < v then
                maxValue = v
            end
        end

        local value = maxValue
        if self.clubData.lTableLimit[idx] > maxValue then
            value = self.clubData.lTableLimit[idx]
        end
        return value
    else
        return 0
    end
end

function NewClubInfoLayer:initQuickStartGame()
    local waynum, retIndex = self:getPlayWayNums()
    if waynum <= 0 then
        self.Text_lastRecordName:setVisible(false)
    else
        self.Text_lastRecordName:setVisible(true)
        local recordId = cc.UserDefault:getInstance():getIntegerForKey('club_quick_game_playwayid', 0)
        if recordId == 0 then
            local idx = retIndex[1]
            if self.clubData.szParameterName[idx] ~= "" and self.clubData.szParameterName[idx] ~= " " then
                self.Text_lastRecordName:setString(self.clubData.szParameterName[idx])
            else
                local gameinfo = StaticData.Games[self.clubData.wKindID[idx]]
                self.Text_lastRecordName:setString(gameinfo.name)
            end
        else
            local idx = self:getClubDataIndex(recordId)
            if idx then
                if self.clubData.szParameterName[idx] ~= "" and self.clubData.szParameterName[idx] ~= " " then
                    self.Text_lastRecordName:setString(self.clubData.szParameterName[idx])
                else
                    local gameinfo = StaticData.Games[self.clubData.wKindID[idx]]
                    self.Text_lastRecordName:setString(gameinfo.name)
                end
            else
                local idx = retIndex[1]
                local playwayid = self.clubData.dwPlayID[idx]
                cc.UserDefault:getInstance():setIntegerForKey('club_quick_game_playwayid', playwayid)
                if self.clubData.szParameterName[idx] ~= "" and self.clubData.szParameterName[idx] ~= " " then
                    self.Text_lastRecordName:setString(self.clubData.szParameterName[idx])
                else
                    local gameinfo = StaticData.Games[self.clubData.wKindID[idx]]
                    self.Text_lastRecordName:setString(gameinfo.name)
                end
            end
        end
    end
end

------------------------------------------------------------------------
--一个个返回有人桌子详情
function NewClubInfoLayer:RET_GET_CLUB_TABLE(event)
    local data = event._usedata
    if self.clubData == nil or self.clubData.dwClubID ~= data.dwClubID then
        return
    end
    self:refreshTableOneByOne(data)
end

--亲友圈刷新返回
function NewClubInfoLayer:RET_REFRESH_CLUB(event)
    local data = event._usedata
    Log.d(data)
    if data.dwClubID == 0 or data.dwUserID == 0 then
        cc.UserDefault:getInstance():setIntegerForKey("UserDefault_NewClubID", 0)
        self.ListView_more:removeAllChildren()
        UserData.Guild:getClubList()
        return
    end
    self:megerClubData(data)
    UserData.Guild:saveLastUseClubRecord(self.clubData.dwClubID)
    cc.UserDefault:getInstance():setIntegerForKey("UserDefault_NewClubID", self.clubData.dwClubID)
    self:updateClubInfo()
	UserData.Guild:getPartnerConfig(UserData.User.userID, self.clubData.dwClubID)
	UserData.Guild:getUpdateClubInfo(self.clubData.dwClubID, UserData.User.userID)

    -- if CHANNEL_ID == 10 or CHANNEL_ID == 11  then
    --     local recordTime = cc.UserDefault:getInstance():getIntegerForKey("Temp_Club_Notice", 0)
    --     if self.clubData.dwClubID == 55404967 and not Common:isToday(recordTime) then
    --         self.Panel_tempNotice:setVisible(true)
    --         cc.UserDefault:getInstance():setIntegerForKey("Temp_Club_Notice", os.time())
    --     end
	-- end
	
	-- if CHANNEL_ID == 10 or CHANNEL_ID == 11  then
	-- 	if self.clubData.dwClubID == 55404967 then
	-- 		self.Button_ybFrame:setVisible(false)
	-- 	else
	-- 		self.Button_ybFrame:setVisible(true)
	-- 	end
	-- else
	-- 	self.Button_ybFrame:setVisible(false)
	-- end
end

--返回刷新俱乐部玩法
function NewClubInfoLayer:RET_REFRESH_CLUB_PLAY(event)
    local data = event._usedata
    Log.d(data)

    if data.cbPlayCount <= 10 then
        self.playwayData = {}
    end
    self.playwayData = self.playwayData or {}
    for k,v in pairs(data) do
        if type(v) == 'table' and self.playwayData[k] then
            for m,n in ipairs(v) do
                table.insert(self.playwayData[k], n)
            end
        else
            self.playwayData[k] = v
        end
    end
end

function NewClubInfoLayer:RET_REFRESH_CLUB_PLAY_FINISH(event)
    local data = event._usedata
    self:megerClubData(self.playwayData)
    local curSelPlaywayId = cc.UserDefault:getInstance():getIntegerForKey('CurSelPlaywayId', 0)
    self:createClubTable(curSelPlaywayId)

    local box = self.Image_bottom:getChildByName('NewClubMorePlaywayLayer')
    if not box then
        box = require("app.MyApp"):create(self):createView('NewClubMorePlaywayLayer')
        self.Image_bottom:addChild(box)
        box:setName('NewClubMorePlaywayLayer')
        local isShow = cc.UserDefault:getInstance():getBoolForKey("Is_Show_PlaywayLan", true)
        if not isShow then
            box.Image_CPWAll:setVisible(false)
            self.listView:setPositionY(106)
        end
    end
    local curGameId = cc.UserDefault:getInstance():getIntegerForKey('CurSelGameID', 0)
    box:switchChildPlaywayUI(curGameId)
    self:initQuickStartGame()
end

--更新亲友圈信息
function NewClubInfoLayer:RET_UPDATE_CLUB_INFO(event)
    local data = event._usedata
    Log.d(data)
    self:megerClubData(data)
    self:updateClubInfo()
end

--添加亲友圈牌桌
function NewClubInfoLayer:RET_ADD_CLUB_TABLE(event)
    local data = event._usedata
    if self.clubData == nil or self.clubData.dwClubID ~= data.dwClubID then
        return
    end
    self:refreshTableOneByOne(data)
end

--刷新亲友圈牌桌
function NewClubInfoLayer:RET_UPDATE_CLUB_TABLE(event)
    local data = event._usedata
    if self.clubData == nil or self.clubData.dwClubID ~= data.dwClubID then
        return
    end
    self:refreshTableOneByOne(data)
end

--删除亲友圈牌桌
function NewClubInfoLayer:RET_DEL_CLUB_TABLE(event)
    local data = event._usedata
    Log.d(data)
    if self.clubData == nil or self.clubData.dwClubID ~= data.dwClubID then
        return
    end
    self:removeClubTable(data.dwTableID)
end

--被删除亲友圈
function NewClubInfoLayer:RET_DELED_CLUB(event)
    local data = event._usedata
    if self.clubData.dwClubID == data.dwClubID then
        self:removeFromParent()
    else
        -- local item = self.ListView_more:getChildByName('clubitem_' .. data.dwClubID)
        -- if item then
        --     item:removeFromParent()
        --     self.ListView_more:refreshView()
        -- end
    end
    local str = string.format("您被踢出亲友圈[%d]!",data.dwClubID)
    require("common.MsgBoxLayer"):create(0,nil,str)
end

--返回审核列表
function NewClubInfoLayer:RET_CLUB_CHECK_LIST(event)
    self.Image_checkRedPoint:setVisible(true)
end

--登陆成功(断线重连)
function NewClubInfoLayer:SUB_CL_LOGON_SUCCESS(event)
    local dwClubID = cc.UserDefault:getInstance():getIntegerForKey("UserDefault_NewClubID", 0)
    if dwClubID ~= 0 then
        UserData.Guild:refreshClub(dwClubID)
    else
        require("common.SceneMgr"):switchOperation(require("app.MyApp"):create():createView("NewClubLayer"))
    end
end

--进入后台
function NewClubInfoLayer:EVENT_TYPE_DID_ENTER_BACKGROUND(event)
    if self.clubData then
        UserData.Guild:removeCloseClub(self.clubData.dwClubID)
    end
end

--恢复回来
function NewClubInfoLayer:EVENT_TYPE_WILL_ENTER_FOREGROUND(event)
    local dwClubID = cc.UserDefault:getInstance():getIntegerForKey("UserDefault_NewClubID", 0)
    if dwClubID ~= 0 then
        UserData.Guild:refreshClub(dwClubID)
    else
        require("common.SceneMgr"):switchOperation(require("app.MyApp"):create():createView("NewClubLayer"))
    end
end

--返回亲友圈列表(一个个返回)
function NewClubInfoLayer:RET_GET_CLUB_LIST(event)
    local data = event._usedata
    Log.d(data)
    local dwClubID = cc.UserDefault:getInstance():getIntegerForKey("UserDefault_NewClubID", 0)
    if dwClubID == 0 then
        -- self.clubData = self.clubData or {}
        -- self.clubData.dwClubID = data.dwClubID
        self:megerClubData(data)
        cc.UserDefault:getInstance():setIntegerForKey("UserDefault_NewClubID", data.dwClubID)
        UserData.Guild:refreshClub(data.dwClubID)
    end
    self:addOnceClubItem(data)
end

--没有亲友圈返回
function NewClubInfoLayer:RET_GET_CLUB_LIST_FAIL(event)
    require("common.SceneMgr"):switchOperation(require("app.MyApp"):create():createView("NewClubLayer"))
end

--被添加亲友圈
function NewClubInfoLayer:RET_ADDED_CLUB(event)
    local data = event._usedata
    self:addOnceClubItem(data)
end

--返回亲友圈的房卡
function NewClubInfoLayer:RET_UPDATE_CLUB_ROOMCARD(event)
    local data = event._usedata
    Log.d(data)
    if self.clubData and data.dwClubID == self.clubData.dwClubID then
        self:refreshRoomCardInfo(data)
    end
end

function NewClubInfoLayer:RET_UPDATE_CLUB_PLAYER_INFO(event)
    local data = event._usedata
    Log.d(data)
    if self.clubData.dwClubID == 359949 or self.clubData.dwClubID == 807113 or self.clubData.dwClubID == 110852 or self.clubData.dwClubID == 460861 then
        self.Text_pilaozhi:setString(UserData.Bag:getBagPropCount(1009))
        self.Text_lAntiValue:setString('沉迷值:' .. data.lAntiValue)
    else
        self.Text_pilaozhi:setString(data.lFatigueValue)
    end
    
    self.userOffice = data.cbOffice
    self.userFatigueValue = data.lFatigueValue

    self.Button_mp:setPositionX(-26)
    if UserData.User.userID == self.clubData.dwUserID or self:isAdmin(UserData.User.userID)  then
        self.Button_notice:setVisible(true)
        self.Button_partner:setVisible(true)
        self.Button_share:setVisible(true)
        self.Button_mem:setVisible(true)
        self.Button_fkFrame:setVisible(true)
        self.Text_fkNum:setString(self.clubData.dwPropCount)
    else
        self.Button_notice:setVisible(false)
        self.Button_fkFrame:setVisible(false)
        if self.userOffice == 3 or self.userOffice == 4 then
            -- 合伙人
            self.Button_partner:setVisible(true)
            self.Button_share:setVisible(true)
            if Bit:_and(0x02, self.clubData.bIsDisable) == 0x02 and self.userOffice ~= 2 then
                self.Button_mem:setVisible(true)
            else
                self.Button_mem:setVisible(false)
            end
        else
            --普通成员
            self.Button_partner:setVisible(false)
            self.Button_share:setVisible(false)
            self.Button_mem:setVisible(false)
            self.Button_mp:setPositionX(66)
        end
    end

    -- 暂时只有天娱渠道分享改导入成员功能
    if not (CHANNEL_ID == 10 or CHANNEL_ID == 11) then
        self.Button_share:setVisible(true)
    end
end

function NewClubInfoLayer:RET_SETTINGS_CLUB_MEMBER(event)
    local data = event._usedata
    Log.d(data)
    if (data.cbSettingsType == 6 or data.cbSettingsType == 8) and (data.dwUserID == UserData.User.userID) then
        --疲劳值
        self.userFatigueValue = data.lFatigueValue
        if not (self.clubData.dwClubID == 359949 or self.clubData.dwClubID == 807113 or self.clubData.dwClubID == 110852 or self.clubData.dwClubID == 460861) then
            self.Text_pilaozhi:setString(data.lFatigueValue)
        end
    elseif data.cbSettingsType == 7 or data.cbSettingsType == 11 then
        UserData.Guild:getUpdateClubInfo(self.clubData.dwClubID, UserData.User.userID)
        if data.cbSettingsType == 11 then
            require("common.MsgBoxLayer"):create(0,nil,"赠送成功.")
        end
    end
end


--msg 未读消息返回
function NewClubInfoLayer:RET_CLUB_CHAT_GET_UNREAD_MSG( event )
    local data = event._usedata
    if not self.isClickFirst then
        if self.clubData then
            if self.clubData.dwClubID == data.dwClubID then
                self.Image_chatRedPoint:setVisible(data.isHaveMsg)   
                self.isClickFirst = true
            end
        end
    end     
end

function NewClubInfoLayer:SUB_CL_USER_INFO(event)
    print('刷新名片：', UserData.User.szErWeiMaLogo)
    Common:requestErWeiMaPicture(UserData.User.szErWeiMaLogo, self.Image_mp)
end

function NewClubInfoLayer:RET_SETTINGS_CONFIG(event)
    local data = event._usedata
    Log.d(data)

    if data.lRet ~= 0 then
        --require("common.MsgBoxLayer"):create(0,nil,"获取合伙人配置信息失败！")
        return
    end
    self:megerClubData(data)
end

function NewClubInfoLayer:REFRESH_CLUB_BG(event)
    local data = event._usedata
    dump(data, '刷新俱乐部样式:')

    if data.bg then
        local index = data.bg
        if type(index) == 'number' and index > 0 and index < 5 then
            self.Image_bg:loadTexture(string.format('kwxclub/table/t_%d.jpg', index))
        end
    end

    if data.table or data.isrefresh then
        local curSelPlaywayId = cc.UserDefault:getInstance():getIntegerForKey('CurSelPlaywayId', 0)
        self:createClubTable(curSelPlaywayId)
    end

    if data.bShowPlayway == 0 then
        --隐藏
        local box = self.Image_bottom:getChildByName('NewClubMorePlaywayLayer')
        if box then
            box.Image_CPWAll:setVisible(false)
            self.listView:setPositionY(106)
        end
    elseif data.bShowPlayway == 1 then
        --显示
        local box = self.Image_bottom:getChildByName('NewClubMorePlaywayLayer')
        if box then
            box.Image_CPWAll:setVisible(true)
            self.listView:setPositionY(136)
        end
    end
end

function NewClubInfoLayer:RET_CLUB_SETTING_ANTI_MEMBER(event)
    local data = event._usedata
    dump(data)
    if data.lRet ~= 0 then
        return
    end

    if data.bOperatorType ~= 0 and data.dwUserID == UserData.User.userID then
        if self.clubData.dwClubID == 359949 or self.clubData.dwClubID == 807113 or self.clubData.dwClubID == 110852 or self.clubData.dwClubID == 460861 then
            self.Text_lAntiValue:setString('沉迷值:0')
        end
    end
end

return NewClubInfoLayer
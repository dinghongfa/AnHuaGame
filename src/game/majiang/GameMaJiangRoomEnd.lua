---------------
--   大结算
---------------
local GameMaJiangRoomEnd = class("GameMaJiangRoomEnd", cc.load("mvc").ViewBase)
local StaticData = require("app.static.StaticData")
local UserData = require("app.user.UserData")
local Common = require("common.Common")
local EventMgr = require("common.EventMgr")
local EventType = require("common.EventType")
local GameCommon = require("game.majiang.GameCommon")
local Base64 = require("common.Base64")


local Location = {
	[2] = {
		cc.p(240, 45),
		cc.p(760, 45),
	},
	[3] = {
		cc.p(182, 45),
		cc.p(518, 45),
		cc.p(855, 45),
	},
	[4] = {
		cc.p(48.00, 45),
		cc.p(348.00, 45),
		cc.p(648.00, 45),
		cc.p(950.00, 45),
	}
}

local endDes = {
	[0] = '',
	[1] = '提示：该房间被房主解散',
	[2] = '提示：该房间被管理员解散',
	[3] = '提示：该房间投票解散',
	[4] = '提示：该房间因疲劳值不足被强制解散',
	[5] = '提示：该房间被官方系统强制解散',
	[6] = '提示：该房间因超时未开局被强制解散',
	[7] = '提示：该房间因超时投票解散',
}

function GameMaJiangRoomEnd:onConfig()
	self.widget = {
		{'back', 'onBack'},
		{'lianjie', 'onHistory'},
		{'zhanji', 'onHistory'},
		{'fang_num'},
		{'panel_end'},
		{'text_time'},
		{'text_club'},
		{'text_Gamename'},
		{'panel_end'},
		{'tishi_des'},
	}
end

function GameMaJiangRoomEnd:onEnter()
	require("common.Common"):screenshot(FileName.battlefieldScreenshot)
end

function GameMaJiangRoomEnd:onExit()
	
end

function GameMaJiangRoomEnd:onCreate(params)
	self.pBuffer = params[1]
	self.scoreItem = {}
	if self.pBuffer then
		self.fang_num:setString(self.pBuffer.tableConfig.wTbaleID)
		self.text_Gamename:setString(self.pBuffer.tableConfig.wTbaleID)
		self.text_Gamename:setString("")
		if self.pBuffer.gameDesc ~= nil and self.pBuffer.gameDesc ~= "" then
			self.text_Gamename:setString(string.format("%s",StaticData.Games[self.pBuffer.tableConfig.wKindID].name.."\n"..self.pBuffer.gameDesc))
		else
			self.text_Gamename:setString(string.format("%s",StaticData.Games[self.pBuffer.tableConfig.wKindID].name))
		end
		self.tishi_des:setString(endDes[self.pBuffer.cbOrigin])
		self:playerInfo()
	end
	
	local function onEventRefreshTime(sender, event)
		local date = os.date("*t", os.time())
		self.text_time:setString(string.format("%d-%02d-%02d %02d:%02d:%02d", date.year, date.month, date.day, date.hour, date.min, date.sec))
		--self.text_time:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(onEventRefreshTime)))
	end

	self.template = ccui.Helper:seekWidgetByName(self.panel_end, "template")
	self.center = ccui.Helper:seekWidgetByName(self.panel_end, "center")

	self:updatePlayerInfo(self.pBuffer)
	onEventRefreshTime()
end

function GameMaJiangRoomEnd:onBack(...)
	require("common.SceneMgr"):switchScene(require("app.MyApp"):create():createView("HallLayer"), SCENE_HALL)
end

function GameMaJiangRoomEnd:onHistory(...)
    local data = clone(UserData.Share.tableShareParameter[4])
    data.dwClubID = self.pBuffer.tableConfig.dwClubID
    data.szShareTitle = string.format("战绩分享-房间号:%d,局数:%d/%d",self.pBuffer.tableConfig.wTbaleID, self.pBuffer.tableConfig.wCurrentNumber, self.pBuffer.tableConfig.wTableNumber)
    data.szShareContent = ""
    local maxScore = 0
    for i = 1, 8 do
        if self.pBuffer.tScoreInfo[i].dwUserID ~= nil and self.pBuffer.tScoreInfo[i].dwUserID ~= 0 and self.pBuffer.tScoreInfo[i].totalScore > maxScore then 
            maxScore = self.pBuffer.tScoreInfo[i].totalScore
        end
    end
    for i = 1, 8 do
        if self.pBuffer.tScoreInfo[i].dwUserID ~= nil and self.pBuffer.tScoreInfo[i].dwUserID ~= 0 then
            if data.szShareContent ~= "" then
                data.szShareContent = data.szShareContent.."\n"
            end
            if maxScore ~= 0 and self.pBuffer.tScoreInfo[i].totalScore >= maxScore then
                data.szShareContent = data.szShareContent..string.format("【%s:%d(大赢家)】",self.pBuffer.tScoreInfo[i].player.szNickName,self.pBuffer.tScoreInfo[i].totalScore)
            else
                data.szShareContent = data.szShareContent..string.format("【%s:%d】",self.pBuffer.tScoreInfo[i].player.szNickName,self.pBuffer.tScoreInfo[i].totalScore)
            end
        end
    end
    data.szShareUrl = string.format(data.szShareUrl,self.pBuffer.szGameID)
	data.szShareImg = FileName.battlefieldScreenshot
	data.szGameID = self.pBuffer.szGameID;
	data.isInClub = self:isInClub(self.pBuffer);
    require("app.MyApp"):create(data):createView("ShareLayer")
end

function GameMaJiangRoomEnd:isInClub( pBuffer )
    return pBuffer.tableConfig.nTableType == TableType_ClubRoom and pBuffer.tableConfig.dwClubID ~= 0
end

function GameMaJiangRoomEnd:onLianJie(...)
	--
end

function GameMaJiangRoomEnd:isClub(...)
	return self.pBuffer.tableConfig.nTableType == TableType_ClubRoom and self.pBuffer.tableConfig.dwClubID ~= 0
end

function GameMaJiangRoomEnd:playerInfo(...)
	local winner = self:getWinner(self.pBuffer)
	for i = 1, self.pBuffer.dwUserCount do
		local data = self.pBuffer.tScoreInfo[i]
		local isWinner = winner[data.dwUserID] or false
	end
	self.text_club:setString('亲友圈ID: ' .. self.pBuffer.tableConfig.dwClubID)
	self.text_club:setVisible(self:isClub())
	self.lianjie:setVisible(false)
end

function GameMaJiangRoomEnd:updatePlayerInfo(pBuffer)
	dump(pBuffer,'fx-------------->>')
	if not pBuffer then
		return
	end

	local showEnd = {3,10,4,11,12}
	local index = showEnd[i]
	local Pos = Location[pBuffer.dwUserCount]
	
	local winner = self:getWinner(pBuffer)
	
	for i = 1, pBuffer.dwUserCount do
		local item = self.template:clone()
		local tScoreInfo = pBuffer.tScoreInfo[i]
		local uiimage_player = ccui.Helper:seekWidgetByName(item, "image_player")
		Common:requestUserAvatar(tScoreInfo.dwUserID, tScoreInfo.player.szPto, uiimage_player, "clip")
		local uiname = ccui.Helper:seekWidgetByName(item, "name")

        local name = Common:getShortName(tScoreInfo.player.szNickName,8,6)
        uiname:setString(name)

		-- uiname:setString(tScoreInfo.player.szNickName)
		uiname:setColor(cc.c3b(139, 105, 20))
		local uiid = ccui.Helper:seekWidgetByName(item, "id")
		uiid:setString(string.format("ID:%d", tScoreInfo.dwUserID))
		uiid:setColor(cc.c3b(139, 105, 20))
		local uibanker = ccui.Helper:seekWidgetByName(item, "banker")
		if tScoreInfo.dwUserID == pBuffer.dwTableOwnerID then
			uibanker:setVisible(true)
		else
			uibanker:setVisible(false)
		end
		local Image_bigwinner = ccui.Helper:seekWidgetByName(item, "Image_bigwinner")
		Image_bigwinner:setVisible(false)
		if winner[tScoreInfo.dwUserID] then
			Image_bigwinner:setVisible(true)
		end
		for j = 1,4 do
			local index = showEnd[j]
			local uiscore = ccui.Helper:seekWidgetByName(item,string.format("score%d",j))
			if  pBuffer.statistics[i][index] ~= nil then 
				uiscore:setText(string.format("%d", pBuffer.statistics[i][index]))
			else
				uiscore:setText("0")
			end 
			if i == 4 then 
				local num =  pBuffer.statistics[i][index] +  pBuffer.statistics[i][showEnd[5]]
				if  num ~= nil then 
					uiscore:setText(string.format("%d", num))
				else
					uiscore:setText("0")
				end 
			end 
		end 
		local uitotal_score = ccui.Helper:seekWidgetByName(item, "total_score")
		local uitotal_score_1 = ccui.Helper:seekWidgetByName(item,'total_score_1');
		uitotal_score:setVisible(tScoreInfo.totalScore >= 0)
		uitotal_score_1:setVisible(tScoreInfo.totalScore < 0)
		if tScoreInfo.totalScore >= 0 then
			uitotal_score:setText(string.format("%d", tScoreInfo.totalScore))
		else
			uitotal_score_1:setText(string.format("%d", tScoreInfo.totalScore))
		end
		--self:updatePlayerStatics(item, pBuffer.statistics[i],tScoreInfo.totalScore)
		uitotal_score:setVisible(false)
		uitotal_score_1:setVisible(false)

		local uiText_result = ccui.Helper:seekWidgetByName(item,"Text_result")
		if tScoreInfo.totalScore >= 0 then
			uiText_result:setTextColor(cc.c3b(175,49,52))
			uiText_result:setString(string.format("+%d\n(赛:%0.2f)",tScoreInfo.totalScore,pBuffer.lWriteScoreArr[i]/100))
		else
			uiText_result:setTextColor(cc.c3b(35,102,69))
			uiText_result:setString(string.format("%d\n(赛:%0.2f)",tScoreInfo.totalScore,pBuffer.lWriteScoreArr[i]/100))
		end

		self.center:addChild(item)
		item:setPosition(Pos[i])
	end
end


function GameMaJiangRoomEnd:getWinner(pBuffer)
	if not pBuffer then
		return
	end
	local max = - 1
	local score = - 1
	local winner = {}
	for i = 1, 8 do
		if not pBuffer.tScoreInfo[i] then
			score = - 1
		else
			score = pBuffer.tScoreInfo[i].totalScore or - 1
		end
		if score >= max then
			max = score
		end
	end
	for i = 1, 8 do
		if not pBuffer.tScoreInfo[i] then
			score = - 1
		else
			score = pBuffer.tScoreInfo[i].totalScore or - 1
		end
		if score == max and max > 0 then
			local id = pBuffer.tScoreInfo[i].dwUserID
			winner[id] = true
		end
	end
	return winner
end

return GameMaJiangRoomEnd 
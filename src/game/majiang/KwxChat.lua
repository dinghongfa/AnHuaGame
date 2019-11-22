---------------
--   聊天
---------------
local KwxChat = class("KwxChat", cc.load("mvc").ViewBase)
local GameCommon = require("game.majiang.GameCommon")
local NetMgr = require("common.NetMgr")
local EventType = require("common.EventType")
local NetMsgId = require("common.NetMsgId")
local EventMgr = require("common.EventMgr")
local Common = require("common.Common")
local MAXNUM = 20 --最大容量
function KwxChat:onConfig()
	self.widget = {
		{'head_2', 'onClickPage'},
		{'head_1', 'onClickPage'},
		{'ListView_chat'},
		{'scrollview_1'},
		{'templateemojj'},
		{'root'},
		{'mask'},
		{'text_template'},
		{'sendClick', 'onSendCall'},
		{'TextField'},
		{'ScrollView_2'},
		{'templateemojj_2'}
	}
	self.pageView = {}
end

function KwxChat:onEnter()
end

function KwxChat:onExit()
end

function KwxChat:onCreate(params)
	self:initOnePage('head_2', 'page_2', handler(self, self.updatePageTwo))
	self:initOnePage('head_1', 'page_1', handler(self, self.updatePageOne))
	self:showPage('head_2') --显示1
	self:moveTo()
	self:initExpression()
	self:initLab()
	--self:initLocalEmoji()
end

function KwxChat:moveTo(...)
	self.mask:setTouchEnabled(true)
	self.mask:addTouchEventListener(function(sender, event)
		if event == ccui.TouchEventType.ended then
			self:moveBack()
		end
	end)
end


function KwxChat:moveBack(...)
	self:removeFromParent()
end

function KwxChat:initOnePage(headName, pageName, call)
	
	local btn = self:seekWidgetByNameEx(self.csb, headName)
	local press = self:seekWidgetByNameEx(btn, 'press')
	local page = self:seekWidgetByNameEx(self.csb, pageName)
	
	self.pageView[headName] = {press, page, call}
end

function KwxChat:updatePageOne(...)
	
end

function KwxChat:updatePageTwo(...)
	
end

function KwxChat:onClickPage(sender)
	self:showPage(sender:getName())
end

function KwxChat:showPage(headName)
	for k, v in pairs(self.pageView) do
		v[1]:setVisible(k == headName)
		v[2]:setVisible(k == headName)
	end
	
	local page = self.pageView[headName]
	if page then
		if page[3] then
			page[3]()
		end
	end
end

function KwxChat:initExpression()
	local name = 'Expression%d.png'
	local imageName = 'anhua/ui/chat/'
	local viewSize = self.scrollview_1:getContentSize()
	for i = 1, 8 do
		local node = self.templateemojj:clone()
		node:setVisible(true)
		node:ignoreContentAdaptWithSize(true)
		local path = string.format(imageName .. name, i)
		node:loadTextures(path, path)
		node:setName(i)
		local size = node:getSize()
		local row = math.floor((i - 1) / 4) -- 5行
		local colum =(i - 1) % 4  -- 3行
		local posx = 55 +((size.width + 15) * colum)
		local posy = viewSize.height - 70 -(size.height + 30) * row
		node:setPosition(posx, posy)
		self:addListener(node, handler(self, self.buttonCall))
		self.scrollview_1:addChild(node)
	end
end

function KwxChat:initLab(...)
	local chat = require("game.anhua.ChatConfig")
	self.text_template:setVisible(false)
	for i = 1, #chat do
		local item = self.text_template:clone()
		item:setVisible(true)
		item:setSwallowTouches(true)
		local des = item:getChildByName('des')
		item:setName(i)
		self:addListener(item, handler(self, self.clickExpressLab))
		des:setString(chat[i].text)
		des:setColor(cc.c3b(99, 73, 41))
		self.ListView_chat:pushBackCustomItem(item)
		self.ListView_chat:refreshView()
	end

end

function KwxChat:initLocalEmoji(...)
	local anim = require("game.anhua.Animation") [23]
	local viewSize = self.ScrollView_2:getContentSize()
	for i = 1, #anim do
		local node = self.templateemojj_2:clone()
		node:setVisible(true)
		local scale = 1
		node:setScale(scale)
		local animData = anim[i]
		local path = ''
		if animData then
			path = animData.animFile
			node:loadTextures(path, path)
			node:ignoreContentAdaptWithSize(true)
		end
		node:setName(i + 100)
		local size = node:getSize()
		local row = math.floor((i - 1) / 4) -- 5行
		local colum =(i - 1) % 4  -- 3行
		local posx = 70 +((size.width * scale ) * colum)
		local posy =(viewSize.height - 70 -(size.height * scale ) * row)
		node:setPosition(posx, posy)
		self:addListener(node, handler(self, self.buttonCall))
		self.ScrollView_2:addChild(node)
	end
end

function KwxChat:clickExpressLab(sender)
	self:moveBack()
	local chat = require("game.anhua.ChatConfig")
	local index = sender:getName() or 1
	local chatContent = chat[tonumber(index)]
	local contents = ''
	if chatContent then
		contents = chatContent.text
	end
	NetMgr:getGameInstance():sendMsgToSvr(NetMsgId.MDM_GR_USER, NetMsgId.REQ_GR_USER_SEND_CHAT, "dwbnsdns",
	GameCommon:getRoleChairID(), tonumber(index), GameCommon:getUserInfo(GameCommon:getRoleChairID()).cbSex, 32, "", string.len(contents), string.len(contents), contents)
end

function KwxChat:onSendCall(...)
	local contents = self.TextField:getString()
	if #contents == 0 then
		return
	end
	self:moveBack()
	NetMgr:getGameInstance():sendMsgToSvr(NetMsgId.MDM_GR_USER, NetMsgId.REQ_GR_USER_SEND_CHAT, "dwbnsdns",
	GameCommon:getRoleChairID(), 0, GameCommon:getUserInfo(GameCommon:getRoleChairID()).cbSex, 32, "", string.len(contents), string.len(contents), contents)
end

function KwxChat:buttonCall(sender)
	self:moveBack()
	local index = sender:getName()
	NetMgr:getGameInstance():sendMsgToSvr(NetMsgId.MDM_GF_GAME, NetMsgId.SUB_GF_USER_EXPRESSION, "ww", index, GameCommon:getRoleChairID())
end

function KwxChat:addListener(btn, callback)
	btn:addTouchEventListener(function(sender, event)
		if event == ccui.TouchEventType.ended then
			Common:palyButton()
			if callback then
				callback(sender)
			end
		end
	end)
end


return KwxChat 
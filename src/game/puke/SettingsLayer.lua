local EventMgr = require("common.EventMgr")
local EventType = require("common.EventType")
local NetMgr = require("common.NetMgr")
local NetMsgId = require("common.NetMsgId")
local UserData = require("app.user.UserData")
local Common = require("common.Common")
local Default = require("common.Default")
local StaticData = require("app.static.StaticData")
local NetMsgId = require("common.NetMsgId")
local GameCommon = require("game.puke.GameCommon") 
local SettingsLayer = class("SettingsLayer", function()
    return ccui.Layout:create()
end)

function SettingsLayer:create(data)
    local view = SettingsLayer.new()
    view:onCreate(data)
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

function SettingsLayer:onEnter()

end

function SettingsLayer:onExit()
    
end

function SettingsLayer:onCleanup()
end

function SettingsLayer:onCreate(data)
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local csb = cc.CSLoader:createNode("AHSetting.csb")
    self:addChild(csb)
    self.root = csb:getChildByName("Image_bg")
    require("common.SceneMgr"):switchOperation(self)  

    if data ~= nil then
		GameCommon = data.parameter[1]
	end
    self.Panel_mask = csb:getChildByName("Panel_mask")
    Common:addTouchEventListener(self.Panel_mask,function() 
        
        cc.UserDefault:getInstance():setIntegerForKey('volumeSelect',self.language)
        --EventMgr:dispatch(EventType.EVENT_TYPE_SKIN_CHANGE,3)
        --require("common.SceneMgr"):switchOperation()
        GameCommon.language = self.language
        self:removeFromParent()
    end,true)


    self.Button_language = ccui.Helper:seekWidgetByName(self.root,"Button_language")
    self.Button_music = ccui.Helper:seekWidgetByName(self.root,"Button_music")
    self.Button_effect = ccui.Helper:seekWidgetByName(self.root,"Button_effect")
    self.language = cc.UserDefault:getInstance():getIntegerForKey('volumeSelect', 1)  --语言 0-普通话 1-方言
	self.Button_language:setBright(not (self.language == 1))	
	self.Button_music:setBright((UserData.Music:getVolumeMusic() > 0))
	self.Button_effect:setBright((UserData.Music:getVolumeSound() > 0))
    Common:addTouchEventListener(self.Button_language,function() 
        UserData.Music:saveVolume()
        self:onLanguageCall()
    end)
    Common:addTouchEventListener(self.Button_music,function() 
        UserData.Music:saveVolume()
        self:onMusicCall()
    end)
    Common:addTouchEventListener(self.Button_effect,function() 
        UserData.Music:saveVolume()
        self:onMusicEffect()
    end)
    -- self:initSound() 
end

function SettingsLayer:onMusicCall()
	if self.Button_music:isBright() then
		UserData.Music:setVolumeMusic(0)
		self.Button_music:setBright(false)
	else
		UserData.Music:setVolumeMusic(1)
		self.Button_music:setBright(true)
	end
end

function SettingsLayer:onMusicEffect()
	if self.Button_effect:isBright() then
		UserData.Music:setVolumeSound(0)
		self.Button_effect:setBright(false)
	else
		UserData.Music:setVolumeSound(1)
		self.Button_effect:setBright(true)
	end
end

function SettingsLayer:onLanguageCall()
	if self.Button_language:isBright() then
		self.Button_language:setBright(false)
		self.language = 1
	else
		self.Button_language:setBright(true)
		self.language = 0
	end
end

return SettingsLayer
    
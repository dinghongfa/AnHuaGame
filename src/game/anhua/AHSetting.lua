---------------
--   设置界面
---------------
local Common = require("common.Common")
local EventMgr = require("common.EventMgr")
local EventType = require("common.EventType")
local UserData =  require("app.user.UserData")
local AHSetting = class("AHSetting", cc.load("mvc").ViewBase)
local Music = require("app.user.UserData").Music
local GameCommon = require("game.anhua.GameCommon")
function AHSetting:onConfig()
	self.widget = {
		{'Button_close', 'onClose'},
		{'Button_music', 'onMusicCall'},
		{'Button_effect', 'onMusicEffect'},
		{'Button_language', 'onLanguageCall'},
		{'Panel_mask','onClose'},
		{'Button_tingpai'},
		{'Text_tingpai'},
	}
end

function AHSetting:onCreate()
	self.language = cc.UserDefault:getInstance():getIntegerForKey('volumeSelect', 1)  --语言 0-普通话 1-方言
	self.Button_language:setBright(not (self.language == 1))
	
	self.Button_music:setBright((Music:getVolumeMusic() > 0))
	self.Button_effect:setBright((Music:getVolumeSound() > 0))

	self.Button_tingpai:setVisible(false)
	self.Text_tingpai:setVisible(false)
end

function AHSetting:onClose()
	cc.UserDefault:getInstance():setIntegerForKey('volumeSelect',self.language)
	Music:saveVolume()
	if GameCommon ~= nil then 
		GameCommon.language = self.language
	end 
	self:removeFromParent()
end

function AHSetting:onMusicCall()
	if self.Button_music:isBright() then
		Music:setVolumeMusic(0)
		self.Button_music:setBright(false)
	else
		Music:setVolumeMusic(1)
		self.Button_music:setBright(true)
	end
end

function AHSetting:onMusicEffect()
	if self.Button_effect:isBright() then
		Music:setVolumeSound(0)
		self.Button_effect:setBright(false)
	else
		Music:setVolumeSound(1)
		self.Button_effect:setBright(true)
	end
end

function AHSetting:onLanguageCall()
	if self.Button_language:isBright() then
		self.Button_language:setBright(false)
		self.language = 1
	else
		self.Button_language:setBright(true)
		self.language = 0
	end
end

return AHSetting 
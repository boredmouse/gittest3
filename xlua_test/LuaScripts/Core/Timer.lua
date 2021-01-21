--------------------------------------------------------------------------------
--      Copyright (c) 2015 , 蒙占志(topameng) topameng@gmail.com
--      All rights reserved.
--      Use, modification and distribution are subject to the "MIT License"
--------------------------------------------------------------------------------
local setmetatable = setmetatable

local Time = CS.UnityEngine.Time


LuaClass.Timer = class("Timer")
---@class Timer
local Timer = LuaClass.Timer

--unscaled false 采用deltaTime计时，true 采用 unscaledDeltaTime计时
function Timer:ctor(func, duration, loop, unscaled)
	unscaled = unscaled or false and true	
	loop = loop or 1
	self:Reset(func, duration, loop, unscaled)
end

function Timer:Start()
	self.running = true

	if not self.handle then
		self.handle = function() return self:Update() end
	end

	App.updateBeat:add(self.handle)
end

function Timer:Reset(func, duration, loop, unscaled)
	self.duration 	= duration
	self.loop		= loop or 1
	self.unscaled	= unscaled or false and true
	self.func		= func
	self.time		= duration		
end

function Timer:Stop()
	self.running = false

	if self.handle then
		App.updateBeat:remove(self.handle)
	end
end

function Timer:Update()
	if not self.running then
		return
	end

	local delta = self.unscaled and Time.unscaledDeltaTime or Time.deltaTime	
	self.time = self.time - delta
	
	if self.time <= 0 then
		self.func()
		
		if self.loop > 0 then
			self.loop = self.loop - 1
			self.time = self.time + self.duration
		end
		
		if self.loop == 0 then
			self:Stop()
		elseif self.loop < 0 then
			self.time = self.time + self.duration
		end
	end
end

--给协同使用的帧计数timer
LuaClass.FrameTimer = class("FrameTimer")

---@class FrameTimer
local FrameTimer = LuaClass.FrameTimer

function FrameTimer:ctor(func, count, loop)
	self:Reset(func, count, loop)
	self.running = false
end

function FrameTimer:Reset(func, count, loop)
	self.func = func
	self.duration = count
	self.loop = loop or 1
	self.count = Time.frameCount + count	
end

function FrameTimer:Start()		
	if not self.handle then
		self.handle = function() return self:Update() end
	end

	App.lateUpdateBeat:add(self.handle)
	self.running = true
end

function FrameTimer:Stop()	
	self.running = false

	if self.handle then
		App.lateUpdateBeat:remove(self.handle)
	end
end

function FrameTimer:Update()	
	if not self.running then
		return
	end

	if Time.frameCount >= self.count then
		self.func()	
		
		if self.loop > 0 then
			self.loop = self.loop - 1
		end
		
		if self.loop == 0 then
			self:Stop()
		else
			self.count = Time.frameCount + self.duration
		end
	end
end

LuaClass.CoTimer = class("CoTimer")

local CoTimer = LuaClass.CoTimer

function CoTimer:ctor(func, duration, loop)
	self:Reset(func, duration, loop)
	self.running = false
end

function CoTimer:Start()		
	if not self.handle then
		self.handle = function() return self:Update() end
	end
	
	self.running = true
	App.coUpdateBeat:add(self.handle)
end

function CoTimer:Reset(func, duration, loop)
	self.duration 	= duration
	self.loop		= loop or 1	
	self.func		= func
	self.time		= duration		
end

function CoTimer:Stop()
	self.running = false

	if self.handle then
		App.coUpdateBeat:remove(self.handle)
	end
end

function CoTimer:Update()	
	if not self.running then
		return
	end

	if self.time <= 0 then
		self.func()		
		
		if self.loop > 0 then
			self.loop = self.loop - 1
			self.time = self.time + self.duration
		end
		
		if self.loop == 0 then
			self:Stop()
		elseif self.loop < 0 then
			self.time = self.time + self.duration
		end
	end
	
	self.time = self.time - Time.deltaTime
end
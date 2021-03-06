--[[
	
	Nonsence Asynchronous event based Lua Web server.
	Author: John Abrahamsen < JhnAbrhmsn@gmail.com >
	
	This module "web" is a part of the Nonsence Web server.
	For the complete stack hereby called "software package" please see:
	
	https://github.com/JohnAbrahamsen/nonsence-ng/
	
	Many of the modules in the software package are derivatives of the 
	Tornado web server. Tornado is also licensed under Apache 2.0 license.
	For more details on Tornado please see:
	
	http://www.tornadoweb.org/
	
	
	Copyright 2011 John Abrahamsen

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

  ]]

local httpserver = pcall(require, 'httpserver') and require('httpserver') or 
	error('Missing module httpserver')
local log = pcall(require, 'log') and require('log') or 
	error('Missing module log')
assert(require('middleclass'), 
	[[Missing required module: MiddleClass 
	https://github.com/kikito/middleclass]])
		
local web = {}

web.RequestHandler = class("RequestHandler")
--[[

	Request handler class.
		
  ]]

function web.RequestHandler:initialize(application, request, kwargs)
	self.application = application
	self.request = request
	self._headers_written = false
	self._finished = false
	self._auto_finish = true
	self._transforms = nil
	
	self:clear()
	
	local function _on_close_callback()
		self:on_connection_close()
	end
	
	if self.request:get("Connection") then
		self.request.connection.stream:set_close_callback(_on_close_callback)
	end
	self:on_creation(kwargs)
end

function web.RequestHandler:on_create(kwargs)
	--[[
	 
		Please redefine this class if you want to do something
		straight after the class has been created.
		
		Parameter can be either a table with kwargs, or a single parameter.
		
	  ]]
end

function web.RequestHandler:head(self, args, kwargs) HTTPError:new(405) end
function web.RequestHandler:get(self, args, kwargs) HTTPError:new(405) end
function web.RequestHandler:post(self, args, kwargs) HTTPError:new(405) end
function web.RequestHandler:delete(self, args, kwargs) HTTPError:new(405) end
function web.RequestHandler:put(self, args, kwargs) HTTPError:new(405) end
function web.RequestHandler:options(self, args, kwargs) HTTPError:new(405) end

function web.RequestHandler:prepare()
	--[[
	
		Redefine this method after your likings.
		Called before get/post/put etc. methods on a request.
		
	  ]]
end

function web.RequestHandler:on_finish()
	--[[ 
	
		Redefine this method after your likings.
		Called after the end of a request.
		Usage of this method could be something like a clean up etc.
		
	  ]]
end

function web.RequestHandler:on_connection_close()
	--[[
		
		Called in asynchronous handlers when the connection is closed.
		Use it to clean up the mess after the connection :-).
		
	  ]]
end

function web.RequestHandler:clear()
	-- Reset all headers and content for this request.
	-- TODO make this function :P
	
end

function web.RequestHandler:set_default_headers()
	-- Redefine this method to set HTTP headers at the beginning of
	-- the request.
end

function web.RequestHandler:set_status(status_code)
	-- Sets the status for our response.
	
	assert(type(status_code) == "int", [[set_status method requires int.]])
	self._status_code = status_code
end

function web.RequestHandler:get_status()
	-- Returns the status code currently set for our response.
	
	return self._status_code
end

function web.RequestHandler:add_header(key, value)
	-- Add the given response header key and value to the response.

	self.headers:add(key, value)
end

return web

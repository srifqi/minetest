--Minetest
--Copyright (C) 2018 srifqi, Muhammad Rifqi Priyo Susanto
--		<muhammadrifqipriyosusanto@gmail.com>
--
--This program is free software; you can redistribute it and/or modify
--it under the terms of the GNU Lesser General Public License as published by
--the Free Software Foundation; either version 2.1 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU Lesser General Public License for more details.
--
--You should have received a copy of the GNU Lesser General Public License along
--with this program; if not, write to the Free Software Foundation, Inc.,
--51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

local show_password_mismatch = false
local register_name = ""
local login_name = ""

local function connect_server_formspec()
	local servername = gamedata.servername
	local serverdesc = gamedata.serverdescription
	if servername == nil or servername == "" then
		servername = fgettext("(No server name)")
	end
	if serverdesc == nil or serverdesc == "" then
		serverdesc = fgettext("(No server description)")
	end
	local retval =
		"size[12,5.2;true]" ..
		"label[0,0;" .. minetest.formspec_escape(
			minetest.colorize(mt_color_green, servername)) .. " ]" ..
		"label[0,0.35;" .. minetest.formspec_escape(
			minetest.colorize("#BFBFBF", gamedata.address .. ":"
					.. gamedata.port)) .. "]" ..
		"textarea[0.25,1;5,5.1;;;" .. minetest.formspec_escape(
				serverdesc) .. "]" ..
		"label[8.5,1.0;" .. minetest.formspec_escape(
				fgettext("Login to server")) .. "]" ..
		"label[8.5,1.5;" .. minetest.formspec_escape(
				fgettext("Name / Password")) .. "]" ..
		"field[8.77,2.4;3.5,0.5;te_login_name;;" .. minetest.formspec_escape(
				minetest.settings:get("name")) .. "]" ..
		"pwdfield[8.77,3.1;3.5,0.5;te_login_pwd;]" ..
		"button[8.48,3.78;3.51,1;btn_login;" ..
				fgettext("Login") .. "]" ..
		"label[5,1.0;" .. minetest.formspec_escape(
				fgettext("Create new account")) .. "]" ..
		"label[5,1.5;" .. minetest.formspec_escape(
				fgettext("Name / Password")) .. "]" ..
		"field[5.27,2.4;3.5,0.5;te_register_name;;]" ..
		"pwdfield[5.27,3.1;3.5,0.5;te_register_pwd;]"
	if show_password_mismatch then
		retval = retval ..
			"label[5,3.4;" .. minetest.formspec_escape(
					fgettext("Confirm Password") .. " - " ..
					minetest.colorize("#ff3333",
						fgettext("Password mismatch!"))) .. "]"
	else
		retval = retval ..
			"label[5,3.4;" .. minetest.formspec_escape(
					fgettext("Confirm Password")) .. "]"
	end
	retval = retval ..
		"pwdfield[5.27,4.3;3.5,0.5;te_register_pwd2;]" ..
		"button[4.98,4.6;3.51,1;btn_register;" ..
				fgettext("Register and Connect") .. "]" ..
		"button[8.48,4.6;3.51,1;btn_cancel;" .. fgettext("Cancel") .. "]"

	return retval
end

local function connect_server_buttonhandler(this, fields)
--[[
	if fields.te_login_name then
		login_name = fields.te_login_name
	end

	if fields.te_register_name then
		register_name = fields.te_register_name
	end
]]

	if fields.btn_register then
		if fields.te_register_pwd ~= fields.te_register_pwd2 then
			show_password_mismatch = true
			return true
		else
			show_password_mismatch = false
			gamedata.playername = fields.te_register_name
			gamedata.password = fields.te_register_pwd
			gamedata.accountmode = "register"
			core.settings:set("name", fields.te_register_name)
			core.settings:set("address", gamedata.address)
			core.settings:set("remote_port", gamedata.port)
			core.start()
			return true
		end
	end

	if fields.btn_login then
		gamedata.playername = fields.te_login_name
		gamedata.password = fields.te_login_pwd
		gamedata.accountmode = "login"
		core.settings:set("name", fields.te_login_name)
		core.settings:set("address", gamedata.address)
		core.settings:set("remote_port", gamedata.port)
		core.start()
		return true
	end

	if fields.btn_cancel then
		this:delete()
		return true
	end

	return false
end


function create_connect_server_dlg()
	return dialog_create("sp_connect_server",
					connect_server_formspec,
					connect_server_buttonhandler,
					nil)
end

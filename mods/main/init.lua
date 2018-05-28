--  This is the file which manages the main lobby
main = {}

minetest.register_tool("main:teleporter", {
  description = "Teleporter",
	inventory_image = "compass.png",
	on_use = function(itemstack, user, pointed_thing)
    main.open_teleporter_form(user)
  end,
  on_secondary_use = function(itemstack, user, pointed_thing)
    main.open_teleporter_form(user)
  end,
})

main.teleporter_form = ""
function main.create_teleporter_form()
  main.teleporter_form = ("size[4,4]" ..
  "item_image_button[0,0;2,2;mesewars:mese1;mesewars;"..#subgames.get_lobby_players("mesewars").." players]" ..
  "tooltip[mesewars;Mesewars: Eggwars in Minetest!]"..
  "image_button[2,0;2,2;hideandseek.png;hiddenseeker;"..#subgames.get_lobby_players("hiddenseeker").." players]" ..
  "tooltip[hiddenseeker;Hide and Seek!]" ..
  "item_image_button[0,2;2,2;bow:bow;skywars;"..#subgames.get_lobby_players("skywars").." players]" ..
  "tooltip[skywars;Skywars!]")
  return main.teleporter_form
end

function main.open_teleporter_form(player)
  local name = player:get_player_name()
  minetest.show_formspec(name, "main:teleporter", main.create_teleporter_form())
end

minetest.register_on_player_receive_fields(function(player, formname, pressed)
  if formname == "main:teleporter" then
    local name = player:get_player_name()
    if pressed.mesewars then
      subgames.change_lobby(player, "mesewars")
    elseif pressed.hiddenseeker then
      subgames.change_lobby(player, "hiddenseeker")
    elseif pressed.skywars then
      subgames.change_lobby(player, "skywars")
    end
    minetest.close_formspec(name, "main:teleporter")
  end
end)

local spawn = {x=(-11), y=602, z=20}
subgames.register_on_joinplayer(function(player, lobby)
  if lobby == "main" then
    local name = player:get_player_name()
    player:setpos(spawn)
    local inv = player:get_inventory()
    inv:add_item("main", "main:teleporter")
    sfinv.set_page(player, "subgames:lobbys")
    minetest.after(1, function()
      if player:is_player_connected() and minetest.get_player_privs(name).shout then
        main.open_teleporter_form(player)
	subgames.clear_inv(player)
	local inv = player:get_inventory()
    	inv:add_item("main", "main:teleporter")
   	sfinv.set_page(player, "subgames:lobbys")
      end
    end)
  end
end)

function areas.main.dig(pos, node, digger)
  return false
end

function areas.main.place(itemstack, placer, pointed_thing, param2)
  return false
end

subgames.register_on_chat_message(function(name, message, lobby)
  if lobby == "main" and name and message then
    subgames.chat_send_all_lobby("main", "<"..name.."> "..message)
    return true
  end
end)

--  Add chat system
subgames.register_on_respawnplayer(function(player, lobby)
  if lobby == "main" then
    player:setpos(spawn)
  end
end)

subgames.register_on_drop(function(itemstack, dropper, pos, lobby)
  if lobby == "main" then
    return false
  end
end)

--  Add the hub command
minetest.register_chatcommand("hub", {
  params = "",
  description = "Use it to get to the Main Lobby!",
  func = function(user)
    local player = minetest.get_player_by_name(user)
    subgames.change_lobby(player, "main")
  end,
})

function minetest.get_server_status()
  local total = ""
  local skywars = ""
  local mesewars = ""
  local hiddenseeker = ""
  for name, subgame in pairs(player_lobby) do
    if total == "" then
      total = name
    else total = total.. ", "..name
    end
    if subgame == "mesewars" then
      if mesewars == "" then
        mesewars = name
      else mesewars = mesewars.. ", "..name
      end
    elseif subgame == "hiddenseeker" then
      if hiddenseeker == "" then
        hiddenseeker = name
      else hiddenseeker = hiddenseeker.. ", "..name
      end
    elseif subgame == "skywars" then
      if skywars == "" then
        skywars = name
      else skywars = skywars.. ", "..name
      end
    end
  end
   return "# Server: Total = {"..total.."} \n# Server: Mesewars = {"..mesewars.."} \n# Server: Hide and Seek = {"..hiddenseeker.."} \n# Server: Skywars = {"..skywars.."} \n# Server: "..minetest.setting_get("motd")
end

core.get_server_status = minetest.get_server_status

--[[
function main.get_help_form(type)
  local toreturn = (
  "size[6,4]"..
  "button[0,0;2,1;General;general]"..
  "button[0,1;2,1;Mesewars;mesewars]"..
  "button[0,2;2,1;Hide and Seek;hiddenseeker]"..
  "button[0,3;2,1;Skywars;skywars]"..
  "textarea[2,0;4,4;text;INFO;]"
)]]

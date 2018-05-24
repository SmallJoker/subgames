mapblocks = {}

subgames.register_on_dignode(function(pos, oldnode, digger, lobby)
	if lobby == "mesewars" then
	local player = digger:get_player_name()
  local is_block = false
  for nubsave, savepos in ipairs(mapblocks) do
    if savepos == minetest.pos_to_string(pos) then
      is_block = true
      table.remove(mapblocks, nubsave)
    end
  end
  if is_block == false and oldnode.name ~= "mesewars:mese1" and oldnode.name ~= "mesewars:mese2" and oldnode.name ~= "mesewars:mese3" and oldnode.name ~= "mesewars:mese4" then
    minetest.chat_send_player(player, "You can only dig blocks placed during the Game!")
	  minetest.set_node(pos, oldnode)
	end
	end
end)

subgames.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing, lobby)
	if lobby == "mesewars" then
  if newnode.name == "tnt:tnt_burning" or newnode.name == "default:sandstone" or newnode.name == "default:obsidian" or newnode.name == "default:glass" or newnode.name == "default:steelblock" or newnode.name == "default:chest" then
    if oldnode.name ~= "air" then
		  minetest.set_node(pos, oldnode)
    else table.insert(mapblocks, minetest.pos_to_string(pos))
	  end
  else minetest.set_node(pos, oldnode)
  end
	end
end)

subgames.register_on_blast(function(pos, intensity, lobby)
	if lobby == "mesewars" then
		local nodename = minetest.get_node(pos).name
		if nodename == "default:sandstone" or nodename == "default:obsidian" or nodename == "default:glass" or nodename == "default:steelblock" or nodename == "default:chest" then
			for nubsave, savepos in ipairs(mapblocks) do
		    if savepos == minetest.pos_to_string(pos) then
		      table.remove(mapblocks, nubsave)
		    end
		  end
			return true
		else return false
		end
	end
end)

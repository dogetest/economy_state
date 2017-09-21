--dogeconomy protection mod
local FEE = 1

minetest.register_privilege("freedman", {
	description = "Wont pay interaction fee.",
})

local fee=function(player)
  local pname = economy.pname(player)
  if not minetest.check_player_privs(pname,"freedman") then
    if economy.withdraw(pname, FEE, "Interaction fee") then
      dogecoin.transfer(pname, SOURCE_DOGEACC, FEE, "Interaction fee")
      return true
    end
    return false
  end
  return true
end

minetest.register_on_dignode(function(pos, oldnode, digger)
  if not fee(digger) then
    --revert dignode
    local inv = digger:get_inventory()
    local drop = minetest.get_node_drops(oldnode, nil)[1]
    inv:remove_item("main", drop)
    minetest.set_node(pos, oldnode)
  end
end)

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
  if not fee(placer) then
    minetest.set_node(pos, oldnode)
    return true
  end
end)

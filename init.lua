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
    end
  end
end

minetest.register_on_dignode(function(pos, oldnode, digger)
  fee(digger)
end)

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
  fee(placer)
end)

local train_type={
    ["locomotive"     ] = true,
    ["cargo-wagon"    ] = true,
    ["fluid-wagon"    ] = true,
    ["artillery-wagon"] = true,
}
function on_entity_damaged(event) 
    local cause  = event.cause
    local entity = event.entity
    if cause==nil or train_type[cause.type]==nil then return end
    if entity.type ~= "character" then return end
    if event.final_health ~= 0 then return end

    if cause.type=="cargo-wagon" then
        local cargo = cause
        local surface = cargo.surface
        local position = cargo.position
        local inventory = cargo.get_inventory(defines.inventory.cargo_wagon)
        for i=1,#inventory do
            surface.spill_item_stack(position, inventory[i], false, nil, false)

        end
    end

    event.cause.die() 
    entity.health = entity.health + event.final_damage_amount 
end 

script.on_event(defines.events.on_entity_damaged, on_entity_damaged)


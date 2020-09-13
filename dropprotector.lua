_addon.name = 'Drop Protector'
_addon.author = 'Dean James (Xurion of Bismarck)'
_addon.commands = {'dropprotector', 'dp'}
_addon.version = '0.0.1'

packets = require('packets')
items = require('resources').items
config = require('config')

defaults = {
    items = T{}
}
settings = config.load(defaults)

default_protected_items = require('defaults')
custom_protected_items = settings.items

protected_items = T{}

for k, v in ipairs(default_protected_items) do
    table.insert(protected_items, v:lower())
end
for k, v in ipairs(custom_protected_items) do
    table.insert(protected_items, v:lower())
end

windower.register_event('outgoing chunk', function(id, data)
    if id == 0x028 then --drop item packet
        local parsed = packets.parse('outgoing', data)
        local item = windower.ffxi.get_items(0, parsed['Inventory Index'])
        if protected_items:contains(items[item.id].name:lower()) then
            windower.add_to_chat(8, 'Drop Protector prevented you dropping ' .. items[item.id].name)
            return true --prevent the drop
        end
    end
end)

-- windower.register_event('addon command', function(command, item_name)
--     print(command, item_name)
--     if command == 'add' then
--         settings.items:append(item_name)
--         settings:save()
--     elseif command == 'remove' then

--     end
-- end)

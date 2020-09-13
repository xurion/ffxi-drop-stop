_addon.name = 'Drop Stop'
_addon.author = 'Dean James (Xurion of Bismarck)'
_addon.commands = {'dropstop', 'ds'}
_addon.version = '0.0.1'

packets = require('packets')
items = require('resources').items
config = require('config')

defaults = {
    items = ''
}
settings = config.load(defaults)

default_protected_items = require('defaults')
custom_protected_items = T{}

if string.len(settings.items) > 0 then
    for item in settings.items:gmatch("([^,]+)") do
        table.insert(custom_protected_items, item)
    end
end

protected_items = T{}

for k, v in ipairs(default_protected_items) do
    table.insert(protected_items, v:lower())
end
for k, v in ipairs(custom_protected_items) do
    table.insert(protected_items, v:lower())
end

function save_settings()
    settings.items = table.concat(custom_protected_items, ",")
    settings:save()
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

windower.register_event('addon command', function(command, item_name)
    if command == 'add' then
        item_name = item_name:lower()
        if not custom_protected_items:contains(item_name) then
            table.insert(custom_protected_items, item_name)
            table.insert(protected_items, item_name)
            save_settings()
        end
    elseif command == 'remove' then
        item_name = item_name:lower()
        custom_protected_items:delete(item_name)
        protected_items:delete(item_name)
        save_settings()
    end
end)

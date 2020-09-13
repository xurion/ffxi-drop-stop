_addon.name = 'Drop Protector'
_addon.author = 'Dean James (Xurion of Bismarck)'
_addon.commands = {'dropprotector', 'dp'}
_addon.version = '0.0.1'

packets = require('packets')
items = require('resources').items
config = require('config')

defaults = {
    items = L{}
}
settings = config.load(defaults)

default_protected_items = require('defaults')
custom_protected_items = settings.items

protected_items = default_protected_items:extend(custom_protected_items)

-- Sanitise to lower case for easy comparison later
for k, v in ipairs(protected_items) do
    protected_items[k] = v:lower()
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

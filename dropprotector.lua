_addon.name = 'Drop Protector'
_addon.author = 'Dean James (Xurion of Bismarck)'
_addon.commands = {'dropprotector', 'dp'}
_addon.version = '0.0.1'

packets = require('packets')
items = require('resources').items

-- Define all REMA and crafting shields here
-- Also move these to a module
protected = require('defaults')

-- Convert default protected table into usable list of  lower case values
protected_list = L{}
for _, v in ipairs(protected) do
    protected_list:append(v:lower())
end

windower.register_event('outgoing chunk', function(id, data)
    if id == 0x028 then --drop item packet
        local parsed = packets.parse('outgoing', data)
        local item = windower.ffxi.get_items(0, parsed['Inventory Index'])
        if protected_list:contains(items[item.id].name:lower()) then
            windower.add_to_chat(8, 'Drop Protector prevented you dropping ' .. items[item.id].name)
            return true --prevent the drop
        end
    end
end)

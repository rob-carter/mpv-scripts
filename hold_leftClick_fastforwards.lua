function modify_speed(data)
    local state = data['event']

    if state == "down" then
        mp.set_property('speed', 2)
    elseif state == "up" then
        mp.set_property('speed', 1)
    end
end

mp.add_forced_key_binding("MOUSE_BTN0", modify_speed, {complex=true})
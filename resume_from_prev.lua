--[[
    WIP!

    Saves path and position of media when mpv closes
    
    If mpv opens with no media queued up it will then resume the last played media
--]]

function on_unload()
    local path = mp.command_native({'expand-path', '~~home/'})
    local session_data_path = '' .. path .. '/session/session_data.txt'
    
    local vid_path = mp.get_property('path')
    local time_pos = mp.get_property_number('time-pos')
    local session_data = io.open(session_data_path, 'w+')

    if mp.get_property_number('percent-pos') > 98 then
        session_data:write('')
    else
        session_data:write(vid_path .. '\n' .. time_pos)
    end

    session_data:close()
end

function on_idle(name, is_idle)
    if not is_idle then return end

    local path = mp.command_native({'expand-path', '~~home/'})
    local session_data_path = '' .. path .. '/session/session_data.txt'

    local array = {}
    local session_data = io.open(session_data_path, 'r')

    if session_data then 
        for line in session_data:lines() do
            table.insert(array, line)
        end

        session_data:close()

        if array[1] and array[2] then
            mp.commandv('loadfile', array[1], 'replace', 'start=' .. array[2])
        end
    end
end

mp.add_hook("on_unload", 50, on_unload)
mp.observe_property('idle-active', 'bool', on_idle)

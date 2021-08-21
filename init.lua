local M = {}

M.name = "WorkspaceAppBar"
M.version = "1.0"
M.author = "Anton Kastritskiy"
M.license = "MIT"
M.homepage = "https://github.com/antonk52/WorkspaceAppBar.spoon"

M.callbackFunction = nil

local function get_current_app_name()
    return hs.application.frontmostApplication():name()
end

local KEYS = {
    ctrl = 59,
    left = 123,
    right = 124,
}

local DEFAULT_OPTIONS = {
    space_delimiter = '  |  ',
    active_space_sign = '*',
}

local function normalize_options(opts)
    if opts == nil then
        return DEFAULT_OPTIONS
    end

    for k,v in pairs(DEFAULT_OPTIONS) do
        if opts[k] == nil then
            opts[k] = v
        end
    end

    return opts
end

-- TODO:
-- [x] change focused window within the same space
-- [ ] broken space number detection
-- [ ] support multiscreen setup

function M.start(opts)
    opts = normalize_options(opts)

    local STATE = {
        current_space = 1,
        spaces = {
            [1] = get_current_app_name(),
        }
    }

    local menubar_item = hs.menubar.new(true)
    local function update_menu_item()
        local new_title = ''
        for k,v in pairs(STATE.spaces) do
            local item = ''

            local delim = ''
            if k ~= 1 then
                delim = opts.space_delimiter
            end

            item = delim .. k .. ':' .. item .. v

            if k == STATE.current_space then
                item = item .. opts.active_space_sign
            end

            new_title = new_title .. item
        end
        menubar_item:setTitle(new_title)
    end
    update_menu_item()

    -- watch for focused window changes on the same sapce
    local app_watcher = hs.application.watcher.new(function (app_name, event_type)
        if event_type == hs.application.watcher.activated then
            STATE.spaces[STATE.current_space] = app_name

            update_menu_item()
        end
    end)
    app_watcher:start()

    -- Since the API that `hs.spaces.watcher` has been removed
    -- there is currently no way to detect current workspace number,
    -- therefore here I subscribe to a shortcut for go to next/prev workspace
    --
    -- always returns `false` to avoid swallowing keypresses
    local on_space_move = function (event)
        local key_code = event:getKeyCode()

        if event:getFlags().ctrl == false then
            return false
        end

        if key_code == KEYS.right then
            STATE.current_space = STATE.current_space + 1
            STATE.spaces[STATE.current_space] = get_current_app_name()
            update_menu_item()
        end
        if key_code == KEYS.left then
            -- cannot go beyoud the first space
            if STATE.current_space == 1 then
                return nil
            end
            STATE.current_space = STATE.current_space - 1
            STATE.spaces[STATE.current_space] = get_current_app_name()
            update_menu_item()
        end

        return false
    end
    local eventtap = hs.eventtap.new({hs.eventtap.event.types.keyUp}, on_space_move)
    eventtap:start()
end

return M

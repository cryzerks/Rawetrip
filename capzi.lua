
local Menu = {}

local FFI_Helpers = {
    multi_execute = function(self, ...)
        local arguments = {...}
        for _, command in pairs(arguments) do
          if type(command) ~= 'string' then
            error('[Debug] (Multi Execute) Incorrect command type.', 2) end
    
          console.execute_client_cmd(command)
        end
    end,
      
    multi_color_print = function(self, ...)
        local arguments = {...}
        local length = #arguments
        if length % 2 ~= 0 then
          error('[Debug] (Multi ColorPrint) Incorrect limit.', 2) end
        
        local half = length /2
        for index = 1, half do
          local text  = arguments[index]
          local color = arguments[half + index]
          
          if type(text) ~= 'string' then
            error('[Debug] (Multi ColorPrint) 1/2: not string type') end
          
          if type(color) ~= 'userdata' then
            error('[Debug] (Multi ColorPrint) 2/2: not userdata/color type') end
          
          console.print_color(text, color)
        end
    end,

    string_helpers = {
        animation = function(self, text)
          local animation = {''};
          
          for index = 1, #text do
            local slice = text:sub(1, index)
            table.insert(animation, slice)
          end
      
          table.insert(animation, text)
      
          for index = #animation, 1, -1 do
            local slice = animation[index]
            table.insert(animation, slice)
          end
      
          return animation
        end,
    },

    multitext = function(x, y, _table, alpha)
        alpha = not alpha and 1 or alpha
    
        for a, b in pairs(_table) do
            if not b.font then
                return
            end
    
            b.shadow = b.shadow or false
            b.outline = b.outline or false
            b.color = b.color or color.new(255, 255, 255, 255)
    
            render.text(b.font, x, y, color.new(b.color:r(), b.color:g(), b.color:b(), b.color:a() * alpha), b.text, b.shadow, b.outline)
    
            x = x + render.get_text_width(b.font, b.text)
        end
    end,

    math_helpers = {
        round = function(value, padding)
          if type(value) ~= 'number' then
            error('[Debug] (Rounding) Incorrect value type.', 2) end
          
          local multiplier = 10 ^ (padding or 0);
          return math.floor(value * multiplier + 0.5) / multiplier
        end,
    },

    GetScreenSize = function() 
        return engine.get_screen_width(), engine.get_screen_height() 
    end,

    GetCheatUserName = engine.get_gamename(),

    Lerp = function(a, b, percentage)
        return a + (b - a) * percentage;
    end,

    screen = {
        x = engine.get_screen_width(),
        y = engine.get_screen_height()
    }
}

local _Cheat = {
    Patterns = {
        Clantag = utils.pattern_scan('engine.dll', '53 56 57 8B DA 8B F9 FF 15')
    }, 

    Fonts = {
        Verdana = {
            [12] = render.setup_font('Verdana', 12),
        }, 

        VerdanaBold = {
            [12] = render.setup_font('Verdanab', 12),
            [19] = render.setup_font('Verdanab', 19),
        }, 

        SmallestPixel7 = {
            [10] = render.setup_font('smallest_pixel-7', 10),
        },
    }, 

    Stuff = {
        Screen = FFI_Helpers.GetScreenSize(),

        Status = 'BETA',
        Build = 'alpha',
        Name = 'capzi.lua',
        Version = 2.4,
        Username = FFI_Helpers.GetCheatUserName,
        Avatar = steam.get_user_avatar(),
    }
}

local Memory = {
    KillSay = {
        'бошка взорвалась от моего наплыва',
        'опять дура упала, купи конфиг рял: shoppy.gg/@sadboyzzz',
        'отсосала проститутка хахаха',
        'пиши disconnect обоссанный',
        'жри землю мышь',
        'яйца в щечки и потопал на тот свет',
        'ешки матрешки нихуя ты пули всосал как кончу проглотил',
        'минет делай ханыга',
        'оправдания?',
        'глотай помёт овечка',
        'снимай штаны щас будем петушить',
        'сейчас вантап, а потом что? в ротик?',
        'у тебя еще есть шанс козленыш',
        'сейчас в попу, потом в ротик',
        'лям сюда лям туда, бэктрекед ту africa моча',
        'где мозги потерял шаболда',
        'бегите сука, папочка идет...',
        'братец тут уже нихуя не поможет',
        'передавило ослинской',
        'залил очко спермой',
        'где мозги потерял шаболда',
        'анально наказан',
        'братец ты не с дрейнявом играешь чтобы тебе в ебло не попадали',
        'где носопырку потерял',
        'орять шляпа слетела, анти-попадайки не помогли',
        'бектрекед to africa дегенерат)',
        '-> заползла обратно моча <- тебе в будку',
        'ешки матрешки вот это вантапчик',
        'каадык мне в зад вот это я тебе ебло снес красиво',
        'опять упала дура купи конфиг рял: shoppy.gg/@sadboyzzz',
        'oh my god валера, ты сириусли надеялся меня убить? АХАХ',
        'окажи сопротивление говно, купи конфиг - shoppy.gg/@sadboyzzz',
        'ебло разлетелось на тысячи частиц материи',
    },

    Print = function(text)
        console.print_color(('[%s]'):format('capzi'), color.new(130, 164, 255)) console.print((' %s\n'):format(text))
    end
}

-- * Menu Helper
Menu.Text = function(name, text)
    return ui.add_label(text)
end
    
Menu.Switch = function(text)
    return ui.add_checkbox(text)
end

local Menu_Handler = {

    -- * Tab Control

    Text_1st = Menu.Text('capzi.lua', ('Build: %s'):format(_Cheat.Stuff.Build)),
    Text_2nd = Menu.Text('capzi.lua', ('Last update: %s'):format('1-8-2022')), 

    Menu.Switch('[C] Debug Panel'),
    Menu.Switch('[C] Arrows'),
    Menu.Switch('[C] KillSay'),
    Menu.Switch('[C] Anti-BruteForce'),
    Menu.Switch('[C] Ex Teleport'),
}

local Timer = 12
local Message = 0

local _Render = {
    Memory.Print('Lua successfully loaded!'),

    ['Message'] = function()

        local x, y = 510, 800
        local w, h = 252, 27
        
        local font = _Cheat.Fonts.Verdana[12]
        
        Timer = Timer - globalvars.get_frametime()
        Message = FFI_Helpers.Lerp(Message, Timer <= 0 and 0 or 1, globalvars.get_frametime() * 8)
        
        -- * Background
        render.blur(x, Message*y, w, h, Message*255)
        render.rect_filled(x, Message*y, w, h, color.new(0, 0, 0, Message*200))

        -- * Rects
        -- * Down
        render.rect(x, Message*y + 27, w, 2, color.new(130, 164, 255, Message*255))

        -- * Left
        render.rect(x, Message*y, 2, h, color.new(130, 164, 255, Message*255))

        -- * Right
        render.rect(x + 250, Message*y, 2, h, color.new(130, 164, 255, Message*255))

        -- * Gradient
        render.gradient(x, Message*y, 126, 2, color.new(130, 164, 255, Message*255), color.new(0, 0, 0, Message*0))
        render.gradient(x + 126, Message*y, 126, 2, color.new(0, 0, 0, Message*0), color.new(130, 164, 255, Message*255))

        -- * Text
        local text = ('Welcome back! %s loaded, Build: %s'):format(_Cheat.Stuff.Name, _Cheat.Stuff.Build)

        render.text(font, x + 10, Message*y + 8, color.new(255, 255, 255, Message*255), text, true)
    end,

    ['Panel'] = function()

        if not ui.get_bool('[C] Debug Panel') then
            return 
        end

        local font = _Cheat.Fonts.SmallestPixel7[10]
        local font_2 = _Cheat.Fonts.VerdanaBold[12]

        local text = {
            {font = font, text = 'CAPZI.', shadow = false, outline = true},
            {font = font, text = 'LUA', color = color.new(130, 164, 255), shadow = false, outline = true},
        }

        -- * Position, Size
        local x, y = 10, 450
        local w, h = 110, 40

        render.blur(x, y, w, h, 255)
        render.rect_filled_rounded(x, y, w, h, 60, 7, color.new(0, 0, 0, 180))
        render.image(_Cheat.Stuff.Avatar, x + 5, y + 5, 30, 30, 7)
        FFI_Helpers.multitext(x + 40, y + 5, text)
        render.text(font, x + 86, y + 5, color.new(130, 164, 255), 'BETA', false, true)
        render.text(font_2, x + 40, y + 20, color.new(255, 255, 255), ('@%s'):format(_Cheat.Stuff.Username), true)
    end,

    ['Arrows'] = function()

        local Player = entitylist.get_local_player()
        if not Player then
          return 
        end
    
        if not Player:is_alive() then
          return 
        end

        if not ui.get_bool('[C] Arrows') then
            return 
        end

        local Font = _Cheat.Fonts.VerdanaBold[19]
        local Color = color.new(0, 184, 255)

        local Left = '<'
        local Right = '>'
        local Back = 'v'

        local Pos = {
            Left = {
                x = FFI_Helpers.screen.x/2 - 70,
                y = FFI_Helpers.screen.y/2 - 10,
            },

            Right = {
                x = FFI_Helpers.screen.x/2 + 63,
                y = FFI_Helpers.screen.y/2 - 10,
            },

            Back = {
                x = FFI_Helpers.screen.x/2 - 5,
                y = FFI_Helpers.screen.y/2 + 60,
            }
        }

        render.text(Font, Pos.Left.x, Pos.Left.y, color.new(255, 255, 255), Left, true)
        render.text(Font, Pos.Right.x, Pos.Right.y, color.new(255, 255, 255), Right, true)
        render.text(Font, Pos.Back.x, Pos.Back.y, color.new(255, 255, 255), Back, true)

        if ui.get_keybind_state(keybinds.manual_left) then
            render.text(Font, Pos.Left.x, Pos.Left.y, Color, Left, true)
            render.text(Font, Pos.Right.x, Pos.Right.y, color.new(255, 255, 255), Right, true)
            render.text(Font, Pos.Back.x, Pos.Back.y, color.new(255, 255, 255), Back, true)
        end

        if ui.get_keybind_state(keybinds.manual_right) then
            render.text(Font, Pos.Left.x, Pos.Left.y, color.new(255, 255, 255), Left, true)
            render.text(Font, Pos.Right.x, Pos.Right.y, Color, Right, true)
            render.text(Font, Pos.Back.x, Pos.Back.y, color.new(255, 255, 255), Back, true)
        end

        if ui.get_keybind_state(keybinds.manual_back) then
            render.text(Font, Pos.Left.x, Pos.Left.y, color.new(255, 255, 255), Left, true)
            render.text(Font, Pos.Right.x, Pos.Right.y, color.new(255, 255, 255), Right, true)
            render.text(Font, Pos.Back.x, Pos.Back.y, Color, Back, true)
        end
    end,

    ['KillSay'] = function()
        events.register_event('player_death', function(event)
            if ui.get_bool('[C] KillSay') then
              return 
            end
          
            local player_idx = engine.get_local_player_index()
            
            local userid = event:get_int('userid')
            local attacker = event:get_int('attacker')
            
            local userid_idx = engine.get_player_for_user_id(userid)
            local attacker_idx = engine.get_player_for_user_id(attacker)
            
            if attacker_idx ~= player_idx then
              return 
            end
          
            if userid_idx == player_idx then
              return 
            end
          
            local index = math.random(1, #Memory.KillSay)
            console.execute_client_cmd(('say %s'):format(Memory.KillSay[index]))
        end)
    end,

    ['Ex Teleport'] = function()
        local Player = entitylist.get_local_player()
        if not Player then
          return 
        end
    
        if not Player:is_alive() then
          return 
        end

        if not ui.get_bool('[C] Ex Teleport') then
            return 
        end

        if(ui.get_keybind_state(keybinds.automatic_peek)) then
            ui.set_bool('Antiaim.freestand', true)
        else
            ui.set_bool('Antiaim.freestand', false)
        end
    end,
}

cheat.RegisterCallback('on_paint', function()
    _Render['Message']()
    _Render['Panel']()
    _Render['Arrows']()
end)

cheat.RegisterCallback('on_createmove', function() 
    _Render['KillSay']()
end)
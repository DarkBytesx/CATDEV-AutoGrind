Config['JobList'] = {
    [1] = { -- mining
        position = vector3(2950.9336, 2794.7134, 40.8074),
        labeltext = 'Mining',
        scale = 15.0,
        Animation = {
            animDict = 'melee@large_wpn@streamed_core',
            animName = 'ground_attack_on_spot_body',
        },
        Object = {
            Types = 'Object',
            MaxObject = 10,
            radius = 1.0,
            Job = {
                PropName = 'prop_rock_5_b'
            },
            Player = {
                PropName = 'prop_tool_pickaxe',
                Bone = 57005,
                Pos = {0.16, 0.00, 0.00},
                Ro = {410.0, 20.00, 140.0},
            }
        },
        equipment = {
            working = { 'pickaxe', 'pickaxe2', 'pickaxe3' },
            label = 'Pick Axe'
        },
        -- Agency = {
        --     ['police'] = 1,
        -- },
        UI = {
            item_name = 'stone',
            item_label = 'Stone',
        },
        BackListJob = {
            ['police'] = 0,
            ['ambulance'] = 0,
            ['mechanic'] = 0,
        },
        TakeItem = {
            TimeStandard = 7 * 1000,
            TimeAutoMode = 7 * 1000,
            PickUpMode = 'AUTO'  -- WALK | AUTO | PRESS
        },
        Blips = {
            Sprite = 318,
            Color = 5,
            Size = 0.7,
            Text = '[~g~Auto Collect~w~] Mining',
        },
    },

    [2] = { -- Blue
        position = vector3(2310.6179, 5128.2896, 49.9775),
        labeltext = 'Crystal Blue',
        scale = 15.0,
        Animation = {  -- amb@world_human_gardener_plant@male@idle_a :  : idle_a
            animDict = 'melee@large_wpn@streamed_core',
            animName = 'ground_attack_on_spot_body',
        },
        Object = {
            Types = 'Object',
            MaxObject = 10,
            radius = 1.0,
            Job = {
                PropName = 'notzcrystalzb'
            },
            Player = {
                PropName = 'prop_tool_pickaxe',
                Bone = 57005,
                Pos = {0.09, 0.03, -0.02},
                Ro = {-78.0, 13.0, 28.0},
            }
        },
        equipment = {
            working = { 'pickaxe', 'pickaxe2', 'pickaxe3' },
            label = 'Pick Axe'
        },
        -- Agency = {
        --     ['police'] = 1,
        -- },
        UI = {
            item_name = 'crystal_blue',
            item_label = 'Crystal Blue',
        },
        BackListJob = {
            ['police'] = 0,
            ['ambulance'] = 0,
            ['mechanic'] = 0,
        },
        TakeItem = {
            TimeStandard = 10 * 1000,
            TimeAutoMode = 10 * 1000,
            PickUpMode = 'AUTO'  -- WALK | AUTO | PRESS
        },
        Blips = {
            Sprite = 617,
            Color = 2,
            Size = 0.7,
            Text = '[~g~Auto Collect~w~] Crystals Blue',
        },
    },

    [3] = { -- Green
        position = vector3(2536.8267, 4811.0801, 33.7724),
        labeltext = 'Crystal Green',
        scale = 15.0,
        Animation = {  -- amb@world_human_gardener_plant@male@idle_a :  : idle_a
            animDict = 'melee@large_wpn@streamed_core',
            animName = 'ground_attack_on_spot_body',
        },
        Object = {
            Types = 'Object',
            MaxObject = 10,
            radius = 1.0,
            Job = {
                PropName = 'notzcrystalzg'
            },
            Player = {
                PropName = 'prop_tool_pickaxe',
                Bone = 57005,
                Pos = {0.09, 0.03, -0.02},
                Ro = {-78.0, 13.0, 28.0},
            }
        },
        equipment = {
            working = { 'pickaxe', 'pickaxe2', 'pickaxe3' },
            label = 'Pick Axe'
        },
        -- Agency = {
        --     ['police'] = 1,
        -- },
        UI = {
            item_name = 'crystal_green',
            item_label = 'Crystal Green',
        },
        BackListJob = {
            ['police'] = 0,
            ['ambulance'] = 0,
            ['mechanic'] = 0,
        },
        TakeItem = {
            TimeStandard = 10 * 1000,
            TimeAutoMode = 10 * 1000,
            PickUpMode = 'AUTO'  -- WALK | AUTO | PRESS
        },
        Blips = {
            Sprite = 617,
            Color = 2,
            Size = 0.7,
            Text = '[~g~Auto Collect~w~] Crystals Green',
        },
    },

    [4] = { -- 
        position = vector3(2490.4792, 4857.6831, 36.7413),
        labeltext = 'Crystal Red',
        scale = 15.0,
        Animation = {  -- amb@world_human_gardener_plant@male@idle_a :  : idle_a
            animDict = 'melee@large_wpn@streamed_core',
            animName = 'ground_attack_on_spot_body',
        },
        Object = {
            Types = 'Object',
            MaxObject = 10,
            radius = 1.0,
            Job = {
                PropName = 'notzcrystalzr'
            },
            Player = {
                PropName = 'prop_tool_pickaxe',
                Bone = 57005,
                Pos = {0.09, 0.03, -0.02},
                Ro = {-78.0, 13.0, 28.0},
            }
        },
        equipment = {
            working = { 'pickaxe', 'pickaxe2', 'pickaxe3' },
            label = 'Pick Axe'
        },
        -- Agency = {
        --     ['police'] = 1,
        -- },
        UI = {
            item_name = 'crystal_red',
            item_label = 'Crystal Red',
        },
        BackListJob = {
            ['police'] = 0,
            ['ambulance'] = 0,
            ['mechanic'] = 0,
        },
        TakeItem = {
            TimeStandard = 10 * 1000,
            TimeAutoMode = 10 * 1000,
            PickUpMode = 'AUTO'  -- WALK | AUTO | PRESS
        },
        Blips = {
            Sprite = 617,
            Color = 1,
            Size = 0.7,
            Text = '[~g~Auto Collect~w~] Crystals Red',
        },
    },

    [5] = { -- 
        position = vector3(2605.3699, 4889.1011, 35.9045),
        labeltext = 'Crystal Silver',
        scale = 15.0,
        Animation = {  -- amb@world_human_gardener_plant@male@idle_a :  : idle_a
            animDict = 'melee@large_wpn@streamed_core',
            animName = 'ground_attack_on_spot_body',
        },
        Object = {
            Types = 'Object',
            MaxObject = 10,
            radius = 1.0,
            Job = {
                PropName = 'notzcrystalzs'
            },
            Player = {
                PropName = 'prop_tool_pickaxe',
                Bone = 57005,
                Pos = {0.09, 0.03, -0.02},
                Ro = {-78.0, 13.0, 28.0},
            }
        },
        equipment = {
            working = { 'pickaxe', 'pickaxe2', 'pickaxe3' },
            label = 'Pick Axe'
        },
        -- Agency = {
        --     ['police'] = 1,
        -- },
        UI = {
            item_name = 'crystal_silver',
            item_label = 'Crystal Silver',
        },
        BackListJob = {
            ['police'] = 0,
            ['ambulance'] = 0,
            ['mechanic'] = 0,
        },
        TakeItem = {
            TimeStandard = 10 * 1000,
            TimeAutoMode = 10 * 1000,
            PickUpMode = 'AUTO'  -- WALK | AUTO | PRESS
        },
        Blips = {
            Sprite = 617,
            Color = 55,
            Size = 0.7,
            Text = '[~g~Auto Collect~w~] Crystals Silver',
        },
    },

    [6] = { -- 
        position = vector3(2650.6853, 4695.1357, 36.0856),
        labeltext = 'Crystal Yellow',
        scale = 15.0,
        Animation = {  -- amb@world_human_gardener_plant@male@idle_a :  : idle_a
            animDict = 'melee@large_wpn@streamed_core',
            animName = 'ground_attack_on_spot_body',
        },
        Object = {
            Types = 'Object',
            MaxObject = 10,
            radius = 1.0,
            Job = {
                PropName = 'notzcrystalzy'
            },
            Player = {
                PropName = 'prop_tool_pickaxe',
                Bone = 57005,
                Pos = {0.09, 0.03, -0.02},
                Ro = {-78.0, 13.0, 28.0},
            }
        },
        equipment = {
            working = { 'pickaxe', 'pickaxe2', 'pickaxe3' },
            label = 'Pick Axe'
        },
        -- Agency = {
        --     ['police'] = 1,
        -- },
        UI = {
            item_name = 'crystal_yellow',
            item_label = 'Crystal Yellow',
        },
        BackListJob = {
            ['police'] = 0,
            ['ambulance'] = 0,
            ['mechanic'] = 0,
        },
        TakeItem = {
            TimeStandard = 10 * 1000,
            TimeAutoMode = 10 * 1000,
            PickUpMode = 'AUTO'  -- WALK | AUTO | PRESS
        },
        Blips = {
            Sprite = 617,
            Color = 5,
            Size = 0.7,
            Text = '[~g~Auto Collect~w~] Crystals Yellow',
        },
    },

    [7] = { -- 
        position = vector3(-288.3555, -1637.5691, 31.8988),
        labeltext = 'Crystal Yellow',
        scale = 15.0,
        Animation = {  -- amb@world_human_gardener_plant@male@idle_a :  : idle_a
            animDict = '',
            animName = 'WORLD_HUMAN_WELDING',
        },
        Object = {
            Types = 'Object',
            MaxObject = 10,
            radius = 1.0,
            Job = {
                PropName = 'ruiner3'
            },
            Player = {
                PropName = '',
                Bone = 57005,
                Pos = {0.09, 0.03, -0.02},
                Ro = {-78.0, 13.0, 28.0},
            }
        },
        equipment = {
            working = {'blowtorch'},
            label = 'Blowtorch'
        },
        -- Agency = {
        --     ['police'] = 1,
        -- },
        UI = {
            item_name = 'steel_scrap',
            item_label = 'Steel Scrap',
        },
        BackListJob = {
            ['police'] = 0,
            ['ambulance'] = 0,
            ['mechanic'] = 0,
        },
        TakeItem = {
            TimeStandard = 10 * 1000,
            TimeAutoMode = 10 * 1000,
            PickUpMode = 'AUTO'  -- WALK | AUTO | PRESS
        },
        Blips = {
            Sprite = 326,
            Color = 1,
            Size = 0.7,
            Text = '[~g~Auto Collect~w~] Steel Scrap',
        },
    },
}
Config = {}


Config.Peds = {


{ --Default Config

    name = "Coca 1",									
    pos = vector3(1087.18, -3198.17, -39.99),						
    h = 309.76,											
    color = 6, 											
    scale = 0.8, 										
    model = "mp_f_meth_01", 								
    animation = "WORLD_HUMAN_SMOKING", 					
    resource = "esx_jb_eden_garage2",									
    onEnterText = "Presiona ~INPUT_CONTEXT~ para hablar con el concesionario", 									

},

{ --Default Config

    name = "Coca 2",									
    pos = vector3(1088.46, -3194.68, -39.99),						
    h = 318.78,											
    color = 6, 											
    scale = 0.8, 										
    model = "s_m_y_factory_01", 								
    animation = "WORLD_HUMAN_SMOKING", 					
    resource = "esx_vehicleshop",									
    onEnterText = "Presiona ~INPUT_CONTEXT~ para hablar con el concesionario", 									

},

 { --Default Config

     name = "Coca 3",									
     pos = vector3(1093.02, -3196.59, -39.9),						
     h = 8.61,											
     color = 0, 											
     scale = 0.8, 										
     model = "mp_f_meth_01", 								
     animation = "WORLD_HUMAN_SMOKING", 					
     resource = "esx_jb_eden_garage2",									
     onEnterText = "Presiona ~INPUT_CONTEXT~ para hablar con el concesionario", 									

 },	

 { --Default Config

     name = "Coca 4",									
     pos = vector3(1096.98, -3195.07, -39.99),						
     h = 46.04,											
     color = 6, 											
     scale = 0.8, 										
     model = "mp_f_meth_01", 								
     animation = "WORLD_HUMAN_SMOKING", 					
     resource = "esx_jb_eden_garage2",									
     onEnterText = "Presiona ~INPUT_CONTEXT~ para hablar con el concesionario", 									

},	

{ --Default Config

    name = "Coca 5",									
    pos = vector3(1099.31, -3198.97, -39.99),						
    h = 300.49,											
    color = 6, 											
    scale = 0.8, 										
    model = "mp_f_meth_01", 								
    animation = "WORLD_HUMAN_SMOKING", 					
    resource = "esx_jb_eden_garage2",									
    onEnterText = "Presiona ~INPUT_CONTEXT~ para hablar con el concesionario", 									

},		

	

}

 Config.kordinatlar = {
     aseton = {x = 1090.28, y = -3194.93, z = -38.99, h = 183.53}, -- Embouteillage d'acétone
     damitma = {x = 1092.96, y = -3194.93, z = -38.99, h = 185.62}, -- Distillation d'acétone
     fosfor = {x = 1095.34, y = -3194.92, z = -38.92, h = 183.29}, -- Mélange de phosphore
     aluminyum = {x = 1100.66, y = -3198.81, z = -38.99, h = 179.03}, -- Cuisson / Mélange d'aluminium
 }




 Config.questions = {  -- Regarder le nombre avant la question pour avoir la réponse -- ex 458 = reponse 7 --

     title = 'Cuánto fósforo rojo se necesita para la mezcla ML?',
     steps = {

        [1] = {label = '9.76 GR', value = 1},    -- entre 100 et 150
        [2] = {label = '4.32 GR', value = 2},      -- entre 150 et 200
        [3] =  {label = '15.2 GR', value = 3},    -- entre 200 et 550
        [4] =  {label = '7.54 GR', value = 4},   -- entre 250 et 300
        [5] =  {label = '2.6 GR', value = 5},    -- entre 300 et 350
        [6] =  {label = '19.1 GR', value = 6},    -- entre 350 et 400
        [7] =  {label = '23.76 GR', value = 7},    -- entre 450 et 500
     },

     titletwo = 'La consistencia del material comenzó a solidificarse ¿qué harás??',
     stepstwo = {
        [1] = {label = 'Agregar 3/1 de aluminio a la mezcla', value = 1},
        [2] = {label = 'Separar un poco más.', value = 2},
        [3] = {label = 'Dejar de separar y empaquetarlo.', value = 3},
     },
     titlethree = 'El material empezó a ponerse ligeramente mas blanco, ¿qué vas a hacer?',
     stepsthree = {
        [1] = {label = 'Separar u un poco más.', value = 1},
        [2] = {label = 'Dejar de separar y empaquetarlo.', value = 2},
        [3] = {label = 'Reducir el proceso e ir mas lento', value = 3},
     },
     titlefour = 'El material es blanco y brillante, ¿qué vas a hacer?',
     stepsfour = {
        [1] = {label = 'Separar u un poco más', value = 1},
        [2] = {label = 'Reducir el proceso e ir mas lento', value = 2},
        [3] = {label = 'Dejar de separar y empaquetarlo', value = 3},
     },
 }


----------------------------------------------------------------------
               -- Discord : https://discord.gg/Nf6bpx2jMJ
                           -- Insert#1224
----------------------------------------------------------------------
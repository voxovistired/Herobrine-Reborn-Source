function onCreate()
    makeLuaSprite('bartop','',100,610)
    makeGraphic('bartop',2250,200,'000000')
    addLuaSprite('bartop',true)

    makeLuaSprite('bartop2','',1376,10)
    makeGraphic('bartop2',1280,400,'000000')
    addLuaSprite('bartop2',true)
    setProperty('bartop2.angle', 90)

    makeLuaSprite('bartop2alt','',-576,10)
    makeGraphic('bartop2alt',1280,260,'000000')
    addLuaSprite('bartop2alt',true)
    setProperty('bartop2alt.angle', 90)
    --setObjectCamera('bartop','game')
    --setScrollFactor('bartop',0,0)
    makeLuaSprite('trubg', '08d53fc5-136b-4a50-b57f-834faf921ab4_1', 0, 0)
    --scaleObject('trubg', 0.99, 0.9, true)
    scaleObject('trubg', 10, 10, true)
    screenCenter('trubg')
    addLuaSprite('bg', false, false)
    addLuaSprite('trubg', false)
    makeLuaSprite('bg', 'jd_sleep_bg', 0, 0)
    scaleObject('bg', 0.99, 0.9, true)
    screenCenter('bg')
    addLuaSprite('bg', false, true)
end
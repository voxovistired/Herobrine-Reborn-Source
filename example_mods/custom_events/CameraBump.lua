flippy = false

function onEvent(name, value1, value2)
    if name == 'CameraBump' then
        songPos = getSongPosition()
        flippy = not flippy
            doTweenAngle('bumpyscrumpy', 'camHUD', (flippy and 5 or -5), 0.05)
        end
end
    
function onTweenCompleted(tag)
    if string.find(tag, 'scrumpy') then
        doTweenAngle('bumposcrompo', 'camHUD',0, 0.25, 'circOut')
    end
end
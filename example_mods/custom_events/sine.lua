flippy = false

function onEvent(name, value1, value2)
    if name == 'sine' then
        songPos = getSongPosition()
        for i = 0, getProperty('notes.length') - 1 do
            cancelTween('dsdaw'..i)
            setPropertyFromGroup('notes', i, 'copyX', false)

            strumLine = getPropertyFromGroup('notes', i, 'mustPress') and 'playerStrums' or 'opponentStrums'
            
            time = getPropertyFromGroup('notes', i, 'strumTime')
            receptorX = getPropertyFromGroup(strumLine, getPropertyFromGroup('notes', i, 'noteData') , 'x')
            flippy = not flippy
            doTweenX('doodlysdaw'..i ,'notes.members['..i..']', receptorX + math.sin((songPos - time) / 50) * (flippy and 100 or -100), 0.03)
        end
    end
end

function onTweenCompleted(tag)
    if string.find(tag, 'doodlysdaw') then
        i = string.sub(tag,11,20)
        strumLine = getPropertyFromGroup('notes', i, 'mustPress') and 'playerStrums' or 'opponentStrums'
        receptorX = getPropertyFromGroup(strumLine, getPropertyFromGroup('notes', i, 'noteData') , 'x')
        doTweenX('dsdaw'..i, 'notes.members['..i..']', receptorX, 0.25, 'circOut')
    end
end
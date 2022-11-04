package flx;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class ShootMechanic extends FlxSpriteGroup
{
    public var Text:FlxText;
    var shootactivated:Bool = false;
    public var pivot:Float = FlxG.height * 0.9;
    
    public function new() {
        super(100, 100);
        alpha = 0;
        Text = new FlxText(100, 270, 300, 'PRESS SPACE', 55);
        Text.borderSize = 2.25;
        Text.borderStyle = FlxTextBorderStyle.OUTLINE;
        Text.borderColor = FlxColor.BLACK;
        Text.font = Paths.font("vcr.ttf");
        Text.screenCenter(X);
        Text.updateHitbox();
        add(Text);

        cameras = [PlayState.instance.camHUD];
    }

    var timer:Float = 0.25;
    var hasdodged:Bool = false;

    override public function update(elapsed:Float) {
        if (shootactivated == true)
        {
            if (FlxG.keys.justPressed.SPACE) {
                if (hasdodged == true)
                {
                    trace('already has gone, waiting');
                }
                else
                {
                    timer = 0;
                    var random:Int = FlxG.random.int(1, 2);
                    if (random == 1)
                    {
                        if (PlayState.instance.boyfriend.curCharacter == 'pico')
                            {
                                PlayState.instance.boyfriend.playAnim('dodgeRIGHT');
                                trace(PlayState.instance.boyfriend.animation.curAnim.name);
                                trace('haha');
                            }
                    }
                    else
                    {
                        if (PlayState.instance.boyfriend.curCharacter == 'pico')
                            {
                                PlayState.instance.boyfriend.playAnim('dodgeLEFT');
                                trace(PlayState.instance.boyfriend.animation.curAnim.name);
                                trace('haha');
                            }
                    }
                    hasdodged = true;
                }
            }
            timer -= elapsed;
            if (timer <= 0)
                if (hasdodged != true)
                {
                    FlxG.sound.play(Paths.sound('parry'), 0.5);
                    PlayState.instance.camGame.shake(0.01, 0.1);
                    shootactivated = false;
                    timer = 1;
                    alpha = 0;
                    hasdodged = false;
                    if (PlayState.instance.health - 1 < 0)
                    {
                        PlayState.instance.health = 0;
                    }
                    else
                    {
                        PlayState.instance.health -= 1;
                    }
                }
                else
                {
                    FlxG.sound.play(Paths.sound('parry'), 0.5);
                    PlayState.instance.camGame.shake(0.01, 0.1);
                    hasdodged = false;
                    shootactivated = false;
                    timer = 1;
                    alpha = 0;
                }
        }
        super.update(elapsed);
    }

    public function shoot(time:Float) {
        if (PlayState.instance.dad.curCharacter == 'steev')
        {
            PlayState.instance.dad.playAnim('Shoot');
        }
        shootactivated = true;
        alpha = 1;
        timer = time;
    }
}
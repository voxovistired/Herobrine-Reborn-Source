package flx;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;

class MChearts extends FlxSpriteGroup
{
    public var hp(default, set):Float = 1;
    public function set_hp(n:Float):Float {
        if (n == hp)
            return hp;
        n = FlxMath.roundDecimal(n, 1) * 10;
        for (i in 0...group.maxSize) {
            var name = "right";
            /*if (PlayState.instance.curSong.toLowerCase() == "crashlog" || PlayState.instance.curSong.toLowerCase() == "deletion" || PlayState.instance.curSong.toLowerCase() == "diverge")
            {
                name = "glitch_right";
            }*/
            if (i % 2 == 0)
            {
                name = "left";
                /*if (PlayState.instance.curSong.toLowerCase() == "crashlog" || PlayState.instance.curSong.toLowerCase() == "deletion" || PlayState.instance.curSong.toLowerCase() == "diverge")
                {
                    name = "glitch_left";
                }*/
            }

            if (i < Std.int(n))
                members[i].loadGraphic(Paths.image("hearts/" + name + "_f"));
            else
                members[i].loadGraphic(Paths.image("hearts/" + name + "_e"));
        }
        return n;
    }

    public function new(amount:Int = 10, X:Float = 0, Y:Float = 0) {
        if (amount != 0) // precautions am i right
        {
            final sizeMult:Float = 3.6;

            super(X, Y, amount * 2);
            var adde:Float = 0;
            for (i in 0...amount * 2) {
                var name = "right_f";
                /*if (PlayState.instance.curSong.toLowerCase() == "crashlog" || PlayState.instance.curSong.toLowerCase() == "deletion" || PlayState.instance.curSong.toLowerCase() == "diverge")
                {
                    name = "glitch_right_f";
                }*/
                if (i % 2 == 0)
                {
                    name = "left_f";
                    /*if (PlayState.instance.curSong.toLowerCase() == "crashlog" || PlayState.instance.curSong.toLowerCase() == "deletion" || PlayState.instance.curSong.toLowerCase() == "diverge")
                    {
                        name = "glitch_left_f";
                    }*/
                }
                var heart = new FlxSprite(adde).loadGraphic(Paths.image("hearts/" + name));
                adde += heart.width * sizeMult;
                heart.scale.set(sizeMult, sizeMult);
                heart.updateHitbox();
                add(heart);
            }
        }
    }
}

package flx;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MCbutton extends FlxSpriteGroup
{
    public var bg:FlxSprite;
    public var label:FlxText;

    public var text(default, set):String;

    public var onHover:Void -> Void = null;
    public var onLeave:Void -> Void = null;
    public var onClick:Void -> Void = null;

    function set_text(s:String):String {
        label.text = s;

        return s;
    }

    public function new(X:Float = 0, Y:Float = 0, Text:String = '', Color:Int = 0xff707070) {
        onHover = function() { color = 0xff909090; }
        onLeave = function() { color = 0xffFFFFFF; }

        super(X, Y, 2);

        bg = new FlxSprite().loadGraphic(Paths.image("buttondick"));
        var ps = bg.pixels;
        var w = Std.int(bg.width);
        var h = Std.int(bg.height);

        for (y in 0...h) {
            for (x in 0...w) {
                if (ps.getPixel(x, y) == 0x00ff00) {
                    var val:Int = 100;
                    if (Math.random() > 0.96) {
                        val = FlxG.random.int(85, 105);
                    }
                    ps.setPixel(x, y, FlxColor.fromRGB(val, val, val));
                }
            }
        }

        label = new FlxText(30, -10, 100, '', 20);
        label.font = Paths.font("vcr.ttf");
        label.alignment = CENTER;
        text = Text;
        bg.scale.set(3, 3);
        bg.updateHitbox();
        label.scale.set(3, 3);
        label.updateHitbox();
        add(bg);
        add(label);
    }

    var wasOverlapping:Bool = false;
    override public function update(elapsed:Float) {
        final m:flixel.math.FlxPoint = FlxG.mouse.getPositionInCameraView(FlxG.cameras.list[FlxG.cameras.list.length - 1]);
        final mouseOverlap:Bool = (m.x >= x && m.x <= x + width && m.y >= y && m.y <= y + height);      // kekw 

        if(onHover != null && !FlxG.mouse.pressed && mouseOverlap) {
            onHover();
        }
        if(onLeave != null && wasOverlapping && !mouseOverlap) {
            onLeave();
        }
        if(onClick != null && FlxG.mouse.justPressed && mouseOverlap) {
            onClick();
        }

        wasOverlapping = mouseOverlap;
        super.update(elapsed);
    }
}

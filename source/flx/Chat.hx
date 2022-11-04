package flx;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

typedef Message = {
    text:String,
    yellow:Bool,
    red:Bool
}

class Chat extends FlxSpriteGroup
{
    public var bg:FlxSprite;
    public var label:FlxText;
    public var yello:FlxText;
    public var red:FlxText;
    public static var instance:Chat;

    /**
        * the y position of the bottom left corner of the Chat object 
    **/
    public var pivot:Float = FlxG.height * 0.9;


    public function new() {
        super(0, pivot);
        alpha = 0;

        bg = new FlxSprite().makeGraphic(1, 1, 0x80000000);
        label = new FlxText(0, pivot, 600, '', 20);
        label.font = Paths.font("vcr.ttf");
        yello = new FlxText(0, pivot, 600, '', 20);
        yello.font = Paths.font("vcr.ttf");
        yello.color = 0xffFCFC54;
        red = new FlxText(0, pivot, 600, '', 20);
        red.font = Paths.font("vcr.ttf");
        red.color = 0xffe74848;

        add(bg);
        add(yello);
        add(red);
        add(label);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
    }

    var timer:Float = 0;

    public var messages:Array<Message> = [];

    override public function update(elapsed:Float) {
        bg.updateHitbox();
        bg.y = label.y = yello.y = red.y = (pivot) - label.height;

        timer -= elapsed;
        if (timer <= 0)
            alpha -= elapsed;
        if (alpha <= 0) {
            bg.scale.x = 1;
            label.text = yello.text = red.text = '';
            messages = [];
        }

        super.update(elapsed);
    }

    public function send(Text:String, Yellow:Bool = false, Red:Bool) {
        messages.push({text: Text, yellow: Yellow, red: Red});
        label.text = yello.text = red.text = '';
        for (i in messages) {
            if (i.red) {
                red.text += i.text + "\n";
                yello.text += '\n';
                label.text += '\n';
                FlxTween.tween(red, {x: red.x + 3, y: red.y - 3}, 0.1, {type: PINGPONG});
            }
            if (i.yellow) {
                yello.text += i.text + "\n";
                red.text += '\n';
                label.text += '\n';
            } 
            if (!i.yellow && !i.red) {
                label.text += i.text + "\n";
                red.text += '\n';
                yello.text += '\n';
            }
        }
        bg.scale.x = label.width + 20;
        bg.scale.y = label.height;
        bg.updateHitbox();
        timer = 10;
        alpha = 1;
    }
}

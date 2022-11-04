package menus;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;

using StringTools;

class Credits extends MusicBeatState {
    var CreditSprites:Array<String> = [
        "artists",
        "charters",
        "programmers",
        "voiceactors",
        "musicians",
        "Special Credits"
    ];
    var SpriteThing:Array<FlxSprite> = [];
    var curcredit:Int = 0;
    var Text = new FlxText(0, 0, 0, "PLACEHOLDER", 30, false);
    var Position = new FlxText(0, 50, 0, "PLACEHOLDER", 50, false);
    var cool:Int = 0;
    var cantween:Bool = true;
    var init:Bool = false;


    override public function create() {
        FlxCamera.defaultCameras = [FlxG.camera];
        for (i in 0...CreditSprites.length){ 

            var image = new FlxSprite(0, 0).loadGraphic(Paths.image('credits/${CreditSprites[i]}'));
            image.visible = false;
            image.scale.set(0.21, 0.21);
            image.updateHitbox();
            image.screenCenter(X);
            SpriteThing.push(image);
            add(image);
        }
        Text.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, null, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        Position.setFormat(Paths.font("vcr.ttf"), 50, FlxColor.WHITE, null, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        Change();
        add(Text);
        add(Position);
        FlxG.sound.playMusic(Paths.music('Rebirth'), 0);
        FlxG.sound.music.fadeIn(4, 0, 0.7);
        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        var left = FlxG.keys.justPressed.LEFT;
        var right = FlxG.keys.justPressed.RIGHT;

        if (left)
        {
            Change(-1);
        }
        if (right)
        {
            Change(1);
        }
        if (controls.BACK)
        {
            MusicBeatState.switchState(new menus.MainMenu());
        }
    }
    function Change(change:Int = 0) {
        trace('hi');
        if (cantween != false)
        {
            curcredit += change;
            var cursprite = SpriteThing[curcredit];
            var lastsprite = SpriteThing[curcredit - change];
            if (curcredit < 0)
            {
                curcredit = SpriteThing.length - 1;
                cursprite = SpriteThing[curcredit]; 
                lastsprite = SpriteThing[0];
                trace(curcredit);
            }
            if (curcredit >= CreditSprites.length)
            {
                curcredit = 0;
                cursprite = SpriteThing[curcredit];
                lastsprite = SpriteThing[CreditSprites.length - 1];
                trace(curcredit);
            }
            
            function changetext() {
                cursprite.visible = true;
                trace('hi');
    
                Text.text = StringTools.replace(CreditSprites[curcredit], CreditSprites[curcredit].charAt(0), CreditSprites[curcredit].charAt(0).toUpperCase());
                Text.screenCenter(X);
                Position.text = '< ${curcredit + 1} of ${CreditSprites.length} >';
                Position.screenCenter(X);
            }
            if (init != true) {
                init = true;
                changetext();
                return;
            }
    
            switch (change) {
                case 1:
                    cool = 1000;
                case -1:
                    cool = -1000;
            }
            cantween = false;
            cursprite.x = cool;
            cursprite.alpha = 0;
            changetext();
            trace('hi');
            FlxTween.tween(cursprite, {x: FlxG.width / 2 - cursprite.width / 2, alpha: 1}, 1, {ease: FlxEase.expoOut, onComplete: function(twn:FlxTween) {
                cantween = true;
            }});
            trace('hi');
            FlxTween.tween(lastsprite, {x: -cool, alpha: 0}, 1, {ease: FlxEase.expoOut});
            trace('hi');
        }
    }
}
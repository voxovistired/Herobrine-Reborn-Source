package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

class DeathScreen extends MusicBeatSubstate
{
    public override function create() {
        FlxG.sound.music.volume = 1;
        FlxG.sound.playMusic(Paths.music("gameOver"), 1);
        FlxG.mouse.visible = true;      
        FlxTween.tween(FlxG.camera, {zoom: 1}, 20, {ease: FlxEase.quadIn, type: PINGPONG});

        var opts:Array<Dynamic> = [
            ['Respawn', new PlayState(), Paths.music("gameOverEnd")],
            ['Quit', (PlayState.isStoryMode? new StoryMenuState() : new FreeplayState()), Paths.music("creepyshit")]
        ];

        var loops:Int = 0;
        for (i in opts) {
            var btt = new flx.MCbutton(0, 350 + 100 * loops, i[0]);
            btt.onClick = function() {
                FlxG.sound.playMusic(i[2]);
                new FlxTimer().start(1, function(_) {
                    MusicBeatState.switchState(i[1]);
                });
            }
            btt.scrollFactor.set();
            btt.screenCenter(X);
            add(btt);

            loops++;
        }

        var txt = new FlxText(0, 120, 0, 'You Died!', 30);
        txt.font = Paths.font("vcr.ttf");
        txt.screenCenter(X);
        txt.scale.x = txt.scale.y = 3;
        txt.x += 10;
        add(txt);

        cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
        super.create();
    }

    override public function update(elapsed:Float) {
        Conductor.songPosition += elapsed;

        super.update(elapsed);
    }
}

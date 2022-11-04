package;

import flixel.FlxG;
import flixel.addons.effects.FlxTrail;
import flixel.group.FlxSpriteGroup;

class TraceCharacter extends FlxSpriteGroup
{
    public var char:Character;
    public var trail:FlxTrail;

    public var track:Character;

    public function new(track:Character) {
        this.track = track;
        super();

        char = new Character(this.track.x, this.track.y, this.track.curCharacter, this.track.isPlayer);
        trail = new FlxTrail(char, null, 6, Std.int(6 / (60 / FlxG.drawFramerate)), 0.3333, 0.075);
        char.visible = false;

        add(trail);
        add(char);
    }

    override public function update(elapsed:Float) {
        char.x = track.x;
        char.y = track.y;
        char.scale.x = track.scale.x;
        char.scale.y = track.scale.y;
        char.alpha = track.alpha;
        trail.color = track.color;
        trail.visible = track.visible;

        super.update(elapsed);

        char.playAnim(track.animation.curAnim.name, true, false, track.animation.curAnim.curFrame);

        if (char.animation.curAnim.name == 'attack') {
            var frame = char.animation.curAnim.curFrame;
            var frames = char.animation.getByName('singUP').numFrames;
            if (frames < frame)
                frame = frames;
            char.playAnim('singUP', true, false, frame);
        }
    }
}

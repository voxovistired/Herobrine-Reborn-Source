package badapple;

import flixel.FlxSprite;
import flixel.math.FlxPoint;

@:enum abstract MoveType(Float) from Float
{
    var STRAIGHT = 0;
    var S_ARC = 33;
    var M_ARC = 66;
    var B_ARC = 99;
}

class Bullet extends FlxSprite
{
    public var target:FlxPoint;
    public var movement:MoveType;
                                     // cuz of course it defaults to STRAIGHT🙄 
    public function new(Target:FlxPoint, Movement_type:MoveType = STRAIGHT) {

        super();
    }

    override public function update(_) {

        super.update(_);
    }
}
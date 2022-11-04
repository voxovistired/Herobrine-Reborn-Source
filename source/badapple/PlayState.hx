package badapple;

import flixel.addons.ui.FlxUIState;

class PlayState extends FlxUIState  // here goes nothing 
{
    public var hb:Character = new Character(0, 0, "brin");
    public var bf:Character = new Character(0, 0, "bg_steve");

    public var charShader:badapple.Shader = new badapple.Shader();

    override public function create():Void {
        hb.shader = bf.shader = charShader;
        add(hb);
        add(bf);

        super.create();
    }
}
package;

import flixel.system.FlxAssets.FlxShader;

class BinShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        void main() {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
            float avg = (color.r + color.g + color.b) * 0.33333333;
            if (avg > 0.5)
                gl_FragColor = vec4(0.0, avg * color.a, 0.0, color.a);
            else
                gl_FragColor = vec4(0.0, 0.0, 0.0, color.a);
        }
    ')

    public function new() {
        super();
    }
}
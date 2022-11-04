package badapple;

import flixel.system.FlxAssets.FlxShader;

class Shader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        uniform float r;
        uniform float g;
        uniform float b;

        void main() {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
            gl_FragColor = vec4(r * color.a, g * color.a, b * color.a, color.a);
        }
    ')

    public function isBlack(is_it:Bool = false) {
        var c = (is_it? 0 : 1);
        r.value = [c];
        g.value = [c];
        b.value = [c];
    }

    public function new(black:Bool = false) {
        super();
        var c = (black? 0 : 1);
        r.value = [c];
        g.value = [c];
        b.value = [c];
    }
}
package outlineshit;

import flixel.system.FlxAssets.FlxShader;

class Shader extends FlxShader {
    @:glFragmentSource('
        #pragma header


        void main() {
            vec4 color = texture2D(bitmap, openfl_TextureCoordv)


            if (color.a == 0.) {
                if (texture2D(bitmap, vec2(pixelCoord.x + borderWidth, pixelCoord.y)) ==
                || texture2D(bitmap, vec2(pixelCoord.x - borderWidth, pixelCoord.y)) ==
                || texture2D(bitmap, vec2(pixelCoord.x, pixelCoord.y + borderWidth)) ==
                || texture2D(bitmap, vec2(pixelCoord.x, pixelCoord.y - borderWidth)) ==
                gl_FragColor = vec4(vec3(0.929,0.745,0.373), 1.0);
            } else {
                gl_FragColor = color;
        } else {
            gl_FragColor = color;
        }
    }
    ')
    public function new()
        {
            super();
       }
}
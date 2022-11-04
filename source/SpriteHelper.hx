package;

import openfl.display.BitmapData;
import sys.io.File;

class SpriteHelper
{
    public static function mergeBitmaps(bmp:Array<BitmapData>) {}

    public static function saveBitmap(name:String, bmp:BitmapData, type:lime.graphics.ImageFileFormat = JPEG, quality:Int = 90) {
        var ext = "";
        switch (type) {
            case JPEG: ext = ".jpeg";
            case PNG: ext = ".png";
            case BMP: ext = ".bmp";
        }
        var bytes:openfl.utils.ByteArray = new openfl.utils.ByteArray();
        bytes.writeBytes(openfl.utils.ByteArray.fromBytes(bmp.image.encode(type, quality)));
        File.saveBytes(name + ext, bytes);
    }
}
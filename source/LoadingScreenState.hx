package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;
#if windows
import Discord.DiscordClient;
#end
#if cpp
import sys.FileSystem;
import sys.io.File;
#end


class LoadingScreenState extends MusicBeatState
{
	var barProgression:Float = 0;

	var loadingBarBG:FlxSprite;
    var loadingBar:FlxBar;
    var loadingWhat:FlxText;
    var bisexuel:Int = 0;
    var totalshitintotalthing:Int;
    var totalthing = [];
	var folderlist = ['achievements', 'credits', 'hearts', 'icons', 'menubackgrounds', 'menuBGs', 'menudifficulties', 'pixelUI', 'storymenu',
						'titlecards', 'stages/alex/poggy', ''];
    var folderlist2 = ['stages/alex/poggy', 'stages/alex', 'stages/badddd', 'stages/cave', 'stages/creepy', 'stages/desert', 'stages/emix', 'stages/epic', 'stages/iseeyou',
						'stages/oldroot', 'stages/plain', 'stages/void', ''];

	//public static var bitmapData:Map<String, FlxGraphic>;
	var music = [];
	var images = [];
	var images2 = [];
	var images3 = [];
	var jsons = [];

	override function create()
	{
		FlxG.save.bind('funkin', 'herobrine');

		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;

		FlxG.mouse.visible = false;

		FlxG.worldBounds.set(0, 0);

		//trace('bruj');

		//bitmapData = new Map<String, FlxGraphic>();
        if(FlxG.save.data.Preload != null && FlxG.save.data.Preload == false) {
			new FlxTimer().start(1, function(tmr:FlxTimer)
                {
                    MusicBeatState.switchState(new TitleState());
                });
		}
		//FlxG.mouse.visible = false;

		//FlxG.worldBounds.set(0,0);

		//trace('bruj 2');
        var bg:FlxSprite = new FlxSprite(0, 100).loadGraphic(Paths.image('nullified-no-signature'));
        bg.screenCenter(X);
        bg.scale.set(bg.scale.x, bg.scale.y);
        add(bg);
        
		//trace('bruj 3');
		var pibbi:FlxSprite = new FlxSprite(0, 210).loadGraphic(Paths.image('logo'));
        //pibbi.scale.set(0, 0);
        pibbi.updateHitbox();
		pibbi.screenCenter();
		add(pibbi);
        FlxTween.tween(pibbi, {y: 240}, 4, {ease: FlxEase.quadInOut, type: PINGPONG});

		//trace('bruj 4');
        loadingBarBG = new FlxSprite(0, 200).loadGraphic(Paths.image('healthBar', 'shared'));
        loadingBarBG.screenCenter(X);
        loadingBarBG.setGraphicSize(Std.int(loadingBarBG.width * 1.2));
        add(loadingBarBG);

		//trace('bruj 5');
        loadingBar = new FlxBar(loadingBarBG.x + 4, loadingBarBG.y + 4, LEFT_TO_RIGHT, Std.int(loadingBarBG.width - 8), Std.int(loadingBarBG.height - 8), this,
            'barProgression', 0, 1);
        loadingBar.numDivisions = 100;
        loadingBar.createFilledBar(FlxColor.ORANGE, FlxColor.PURPLE);
        add(loadingBar);

		//trace('bruj 6');
		loadingWhat = new FlxText(12, 630, "", 12);
		loadingWhat.scrollFactor.set();
		loadingWhat.setFormat("VCR OSD Mono", 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(loadingWhat);


		//trace('bruj 7');
		sys.thread.Thread.create(() -> {
			cache();
		});

		super.create();
	}

	override function update(elapsed) 
	{
		super.update(elapsed);
	}

	function cache()
	{
		//trace('bruj 7.5');

		//trace('bruj 8');
		music = Paths.listSongsToCache();

		//trace('bruj 9');
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/data")))
		{
			if (!i.endsWith(".json"))
				continue;
			jsons.push(i);
			totalthing.push(i);
		}

		//trace('bruj 10');
        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images/characters")))
		{
			if (!i.endsWith(".png"))
				continue;
			images.push(i);
			totalthing.push(i);
		}
		//trace('bruj 100');
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images")))
		{
			if (!i.endsWith(".png"))
				continue;
			images2.push(i);
			totalthing.push(i);
		}


        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images")))
		{
			if (!i.endsWith(".png"))
				continue;
			images2.push(i);
			totalthing.push(i);
		}

		for (ii in folderlist)
		{
			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images/" + ii)))
			{
				if (!i.endsWith(".png"))
					continue;
				images2.push(i);
				totalthing.push(i);
			}
		}

        for (ii in folderlist2)
		{
			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/" + ii)))
			{
				if (!i.endsWith(".png"))
					continue;
				images2.push(i);
				totalthing.push(i);
			}
		}

		////trace('bruj 10000');
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
		{
			if (!i.endsWith(".png"))
				continue;
			images2.push(i);
			totalthing.push(i);
		}

		//trace('bruj 100');

		//trace('bruj 1000');

		////trace('bruj 10000');

		trace('(Dont) Kill yourself');
		//trace('bruj 10000');

        totalshitintotalthing = totalthing.length;
        trace("caching characters...");
		loadingWhat.text = 'Loading characters...';


        for (i in images)
        {
            var replaced = i.replace(".png","");
            FlxG.bitmap.add(Paths.image("characters/" + replaced));
            trace("cached " + replaced);
            indiisabitch(replaced);
        }

        
        for (i in images2)
        {
            var replaced = i.replace(".png","");
			for (ii in folderlist)
			{
				FlxG.bitmap.add(Paths.image(ii + "/" + replaced));
				trace("cached " + replaced);
				indiisabitch(replaced);
			}
        }

        for (i in images3)
        {
            var replaced = i.replace(".png","");
            FlxG.bitmap.add(Paths.image(replaced, 'shared'));
            trace("cached " + replaced);
            indiisabitch(replaced);
        }

		for (i in jsons)
		{
			var replaced = i.replace(".json","");
			FlxG.bitmap.add(Paths.json(replaced));
			trace("cached " + replaced);
			indiisabitch(replaced);
		}

        for (i in music)
		{
			var inst = Paths.inst(i);
			if (Paths.doesSoundAssetExist(inst))
			{
				FlxG.sound.cache(inst);
				totalthing.push(inst);
				indiisabitch(inst);
			}

			var voices = Paths.voices(i);
			if (Paths.doesSoundAssetExist(voices))
			{
				FlxG.sound.cache(voices);
				totalthing.push(voices);
				indiisabitch(voices);
			}
		}

        FlxG.switchState(new TitleState());
	}
    function indiisabitch(pussy:String) {
        totalthing.pop();
        bisexuel++;
        loadingWhat.y = 620;
        FlxTween.tween(loadingWhat, {y: 620}, 0.3, {onComplete: function(twn:FlxTween)
            {
                FlxTween.tween(loadingWhat, {y: 630}, 0.3);
            }});
        loadingWhat.text = 'Loaded .. ' + pussy + '(' + bisexuel + '/' + totalshitintotalthing + ')';
        loadingWhat.screenCenter(X);
        barProgression = bisexuel / totalthing.length / 10;
        trace(bisexuel);
    }
}

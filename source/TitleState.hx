package;

#if desktop
import Discord.DiscordClient;
import sys.io.Process;
import sys.thread.Thread;
#end
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import options.GraphicsSettingsSubState;
//import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMatrix;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import openfl.geom.Point;

#if sys
import sys.io.Process;
#end

#if !flash 
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
#end

using StringTools;
typedef TitleData =
{

	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	gfx:Float,
	gfy:Float,
	backgroundSprite:String,
	bpm:Int
}
class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var BackG:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var scary:Bool = false;
	public var camlmao:FlxCamera;
	
	var titleTextColors:Array<FlxColor> = [0xFF33FFFF, 0xFF3333CC];
	var titleTextAlphas:Array<Float> = [1, .64];

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	var mustUpdate:Bool = false;

	var titleJSON:TitleData;

	public static var updateVersion:String = '';
	var daPitch:Float = 1;

	public static var streamer:Bool = false;

	override public function create():Void
	{
		CoolUtil.takeOutTheTrash();

		var taskList = new Process("tasklist", []);
		var hereyouare = taskList.stdout.readAll().toString().toLowerCase();
		var checkProgram:Array<String> = ['obs64.exe', 'obs32.exe', 'streamlabs obs.exe', 'streamlabs obs32.exe'];
		for (i in 0...checkProgram.length)
		{
			if (hereyouare.contains(checkProgram[i]))
			{
				streamer = true;
			}
		}
		taskList.close();
		daPitch = 1;
		camlmao = new FlxCamera();
		FlxG.cameras.reset(camlmao);
		FlxCamera.defaultCameras = [camlmao];
		CustomFadeTransition.nextCamera = camlmao;

		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end
		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		WeekData.loadTheFirstEnabledMod();

		//trace(path, FileSystem.exists(path));

		/*#if (polymod && !html5)
		if (sys.FileSystem.exists('mods/')) {
			var folders:Array<String> = [];
			for (file in sys.FileSystem.readDirectory('mods/')) {
				var path = haxe.io.Path.join(['mods/', file]);
				if (sys.FileSystem.isDirectory(path)) {
					folders.push(file);
				}
			}
			if(folders.length > 0) {
				polymod.Polymod.init({modRoot: "mods", dirs: folders});
			}
		}
		#end*/

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		swagShader = new ColorSwap();
		super.create();

		FlxG.save.bind('funkin', 'herobrine');

		ClientPrefs.loadPrefs();

		#if CHECK_FOR_UPDATES
		if(ClientPrefs.checkForUpdates && !closedState) {
			trace('checking for update');
			var http = new haxe.Http("https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/main/gitVersion.txt");

			http.onData = function (data:String)
			{
				updateVersion = data.split('\n')[0].trim();
				var curVersion:String = MainMenuState.psychEngineVersion.trim();
				trace('version online: ' + updateVersion + ', your version: ' + curVersion);
				if(updateVersion != curVersion) {
					trace('versions arent matching!');
					mustUpdate = true;
				}
			}

			http.onError = function (error) {
				trace('error: $error');
			}

			http.request();
		}
		#end

		Highscore.load();

		// IGNORE THIS!!!
		titleJSON = Json.parse(Paths.getTextFromFile('images/gfDanceTitle.json'));

		if(!initialized)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
				//trace('LOADED FULLSCREEN SETTING!!');
			}
			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		}else if(ClientPrefs.crashedlog == true) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				if (initialized)
					startIntro();
			});
		} else {
			#if desktop
			if (!DiscordClient.isInitialized)
			{
				DiscordClient.initialize();
				Application.current.onExit.add (function (exitCode) {
					DiscordClient.shutdown();
				});
			}
			#end

			if (initialized)
				startIntro();
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startIntro();
				});
			}
		}
		#end
	}

	var logoBl:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var swagShader:ColorSwap = null;
	var rainSprite:FlxSprite;
	var Herobrineee:FlxSprite;
	var LightingShit:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			/*var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;*/

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();

			if(FlxG.sound.music == null) {
				FlxG.sound.playMusic(Paths.music('creepyshit'), 0);
			}
		}

		Conductor.changeBPM(titleJSON.bpm);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('Herobrine-Reborn-Thumbnail-BG'));
		bg.screenCenter();
		bg.cameras = [camlmao];

		rainSprite = new FlxSprite();
		rainSprite.frames = Paths.getSparrowAtlas('rain');
		rainSprite.cameras = [camlmao];
		rainSprite.antialiasing = ClientPrefs.globalAntialiasing;
		rainSprite.animation.addByPrefix('rain', 'rain tho', 24);
		rainSprite.animation.play('rain');
		rainSprite.updateHitbox();
		rainSprite.animation.play('rain', true);
		rainSprite.alpha = 0.5;

		// bg.antialiasing = ClientPrefs.globalAntialiasing;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		logoBl = new FlxSprite(titleJSON.titlex, titleJSON.titley);
		logoBl.frames = Paths.getSparrowAtlas('brin_logo');

		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.animation.addByPrefix('bump', 'brin logoBumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		logoBl.cameras = [camlmao];
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		swagShader = new ColorSwap();
		
		Herobrineee = new FlxSprite(titleJSON.gfx, titleJSON.gfy);
        Herobrineee.frames = Paths.getSparrowAtlas('menu_brin');
		Herobrineee.animation.addByPrefix('brine', 'brin', 24, false);
		Herobrineee.animation.play('brine');
		Herobrineee.antialiasing = ClientPrefs.globalAntialiasing;
		Herobrineee.scale.set(Herobrineee.scale.x / 1.9, Herobrineee.scale.y / 1.9);
		Herobrineee.updateHitbox();
		Herobrineee.cameras = [camlmao];

		add(Herobrineee);
		Herobrineee.shader = swagShader.shader;
		
		add(logoBl);
		logoBl.shader = swagShader.shader;
		add(rainSprite);
		rainSprite.shader = swagShader.shader;

		titleText = new FlxSprite(titleJSON.startx, titleJSON.starty);
		#if (desktop && MODS_ALLOWED)
		var path = "mods/" + Paths.currentModDirectory + "/images/titleEnter.png";
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)){
			path = "mods/images/titleEnter.png";
		}
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)){
			path = "assets/images/titleEnter.png";
		}
		//trace(path, FileSystem.exists(path));
		titleText.frames = FlxAtlasFrames.fromSparrow(BitmapData.fromFile(path),File.getContent(StringTools.replace(path,".png",".xml")));
		#else

		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		#end
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		titleText.cameras = [camlmao];
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = ClientPrefs.globalAntialiasing;

		credGroup = new FlxGroup();
		credGroup.cameras = [camlmao];
		add(credGroup);
		textGroup = new FlxGroup();
		textGroup.cameras = [camlmao];

		BackG = new FlxSprite().loadGraphic(Paths.image('Herobrine-Reborn-Thumbnail-BG'));
		BackG.cameras = [camlmao];
		credGroup.add(BackG);
		credGroup.add(rainSprite);
		
		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();
		credTextShit.cameras = [camlmao];

		credTextShit.visible = false;

		LightingShit = new FlxSprite(-200, -200);
		LightingShit.frames = Paths.getSparrowAtlas('lightning');
		LightingShit.animation.addByPrefix('poop', 'lightning', 24, false);
		LightingShit.antialiasing = ClientPrefs.globalAntialiasing;
		LightingShit.updateHitbox();
		LightingShit.visible = false;
		LightingShit.cameras = [camlmao];
		add(LightingShit);

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = ClientPrefs.globalAntialiasing;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else if (ClientPrefs.crashedlog)
		{
			initialized = true;
			new FlxTimer().start(20, function(tmr:FlxTimer)
			{
				PlayState.storyWeek = 1;
				PlayState.campaignScore = 0;
				PlayState.campaignMisses = 0;
				WeekData.reloadWeekFiles(true);
				WeekData.setDirectoryFromWeek(WeekData.weeksLoaded.get(WeekData.weeksList[1]));
				var songLowercase:String = Paths.formatToSongPath("deletion");
				trace("loading Glitched Herobrin");
				PlayState.SONG = Song.loadFromJson(songLowercase, songLowercase);
				PlayState.storyPlaylist = ['deletion', 'diverge'];
				PlayState.isStoryMode = true;
				PlayState.storyDifficulty = 0;
				ClientPrefs.crashedlog = false;
				ClientPrefs.saveSettings();
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
		else
			initialized = true;
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));
		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];
		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}
		return swagGoodArray;
	}

	var transitioning:Bool = false;
	private static var playJingle:Bool = false;
	
	var newTitle:Bool = false;
	var titleTimer:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		#if cpp
		@:privateAccess
		{
			if (FlxG.sound.music != null && FlxG.sound.music.playing)
			{
				lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, daPitch);
			}
		}
		#end

		if (ClientPrefs.crashedlog)
		{
			daPitch -= 0.001;
			pressedEnter = false;
			FlxG.camera.alpha -= 0.001;
		}

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}
		
		if (newTitle) {
			titleTimer += CoolUtil.boundTo(elapsed, 0, 1);
			if (titleTimer > 2) titleTimer -= 2;
		}

		// EASTER EGG

		if (initialized && !transitioning && skippedIntro && !ClientPrefs.crashedlog)
		{
			if (newTitle && !pressedEnter)
			{
				var timer:Float = titleTimer;
				if (timer >= 1)
					timer = (-timer) + 2;
				
				timer = FlxEase.quadInOut(timer);
				
				titleText.color = FlxColor.interpolate(titleTextColors[0], titleTextColors[1], timer);
				titleText.alpha = FlxMath.lerp(titleTextAlphas[0], titleTextAlphas[1], timer);
			}
			
			if(pressedEnter)
			{
				FlxTween.tween(FlxG.camera, {x:2000}, 3, {ease: FlxEase.expoInOut});
				FlxTween.tween(logoBl, {y:2000}, 3.4, {ease: FlxEase.expoInOut});
				FlxTween.tween(logoBl, {angle:180}, 3.8, {ease: FlxEase.expoInOut});
				FlxTween.tween(Herobrineee, {x:3000}, 3.4, {ease: FlxEase.expoInOut});
				titleText.color = FlxColor.WHITE;
				titleText.alpha = 1;
				
				if(titleText != null) titleText.animation.play('press');

				FlxG.camera.flash(FlxColor.WHITE, 1);
				LightingShit.animation.play('poop');
				LightingShit.visible = true;
				FlxG.sound.play(Paths.sound('thunder'), 0.7);
				FlxG.camera.flash(ClientPrefs.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);

				transitioning = true;

				new FlxTimer().start(2, function(tmr:FlxTimer)
				{
					MusicBeatState.switchState(new menus.MainMenu());
					closedState = true;
				});
			}
		}

		if (initialized && pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		if(swagShader != null)
		{
			if(controls.UI_LEFT) swagShader.hue -= elapsed * 0.1;
			if(controls.UI_RIGHT) swagShader.hue += elapsed * 0.1;
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var CoolText = new FlxText(0, (i * 60) + 250 + offset, FlxG.width, textArray[i], 100);
			CoolText.setFormat(Paths.font("vcr.ttf"), 100, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			CoolText.screenCenter(X);
			CoolText.scrollFactor.set();
			CoolText.borderSize = 3.25;
			if(credGroup != null && textGroup != null) {
				credGroup.add(CoolText);
				textGroup.add(CoolText);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if(textGroup != null && credGroup != null) {
			var CoolText = new FlxText(0, 0, FlxG.width, text, 100);
			CoolText.setFormat(Paths.font("vcr.ttf"), 100, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			CoolText.screenCenter(X);
			CoolText.y += (textGroup.length * 60) + 250 + offset;
			CoolText.scrollFactor.set();
			CoolText.borderSize = 3.25;
			credGroup.add(CoolText);
			textGroup.add(CoolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	public static var closedState:Bool = false;
	override function beatHit()
	{
		super.beatHit();

		if(logoBl != null)
			logoBl.animation.play('bump', true);

		if(Herobrineee != null)
			Herobrineee.animation.play('brine', true);

		if(!closedState) {
			sickBeats++;
			switch (sickBeats)
			{
				case 1:
					FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music('creepyshit'), 0);
					FlxG.sound.music.fadeIn(4, 0, 0.7);
				case 2:
					if (streamer)
						createCoolText(['Psych Engine by'], -40);
					else if (FlxG.random.bool(50))
					{
						scary = true;
						createCoolText(['Look!'], -40);
					}
					else
					{
						#if PSYCH_WATERMARKS
						createCoolText(['Psych Engine by'], 15);
						#else
						addMoreText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er'], 15);
						#end
					}
				case 4:
					if (streamer)
						addMoreText('Wait A Minute...', 15);
					else if (scary)
					{
						addMoreText('BEHIND YOU!', 15);
					}
					else
					{
						#if PSYCH_WATERMARKS
						addMoreText('Shadow Mario', 15);
						addMoreText('RiverOaken', 15);
						addMoreText('shubs', 15);
						#else
						addMoreText('present');
						#end
					}
				case 5:
					deleteCoolText();
				case 6:
					if (streamer)
						createCoolText(['Are You..'], -40);
					else if (scary)
						createCoolText(['HA HA!'], -40);
					else
					{
						#if PSYCH_WATERMARKS
						createCoolText(['Not associated', 'with'], -40);
						#else
						createCoolText(['In association', 'with'], -40);
						#end
					}
				case 8:
					if (streamer)
						addMoreText('No Way...', 15);
					else if (scary)
					{
						addMoreText('MADE YOU LOOK!', 15);
						scary = false;
					}
					else
					{
						addMoreText('newgrounds', 15);
					}
				case 9:
					deleteCoolText();
				case 10:
					if (streamer)
						createCoolText(['Bro FR?'], -40);
					else
						createCoolText(['V1 Took'], -40);
				case 12:
					if (streamer)
						addMoreText('U Recording/Streamin?', -40);
					else
						addMoreText('5 Days LOL', 15);
				case 13:
					deleteCoolText();
				case 14:
					if (streamer)
						createCoolText(['On God?'], -40);
					else
						createCoolText(['Anyways'], -40);
				case 16:
					if (streamer)
						addMoreText('No Cap?', 15);
					else
						addMoreText('Random Quote Time.', 15);
				case 17:
					deleteCoolText();
				case 18:
					createCoolText([curWacky[0]], -40);
				case 20:
					addMoreText(curWacky[1], 15);
				case 21:
					deleteCoolText();
				case 22:
					curWacky = FlxG.random.getObject(getIntroTextShit());
					createCoolText([curWacky[0]], -40);
				case 24:
					addMoreText(curWacky[1], 15);
				case 25:
					deleteCoolText();
				case 26:
					curWacky = FlxG.random.getObject(getIntroTextShit());
					createCoolText([curWacky[0]], -40);
				// credTextShit.visible = true;
				case 28:
					addMoreText(curWacky[1], 15);
				// credTextShit.text += '\nlmao';
				case 29:
					deleteCoolText();
				case 30:
				if (streamer)
					addMoreText('Why', -40);
				else
					addMoreText('Vs.', -40);
				case 31:
					if (streamer)
						addMoreText('Hello', 15);
					else
						addMoreText('Herobrine', 15);
				case 32:
						if (FlxG.random.bool(2) && streamer)
							addMoreText(Sys.environment()["USERNAME"], 15); // credTextShit.text += '\nFunkin';
					else if (streamer)
						addMoreText('Chat', 15); // credTextShit.text += '\nFunkin';
					else
						addMoreText('REBORN', 45);
				case 33:
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;
	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);
			remove(credGroup);
			FlxG.camera.flash(FlxColor.WHITE, 3.4);
			skippedIntro = true;
		}
	}
}

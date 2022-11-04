package;

import flixel.FlxG;

using StringTools;

class Insults
{
    static var deathQuotes:Map<String, Array<String>> = [
        "brin" => [
            "<Herobrine> bruh youre mum last night had more skill then you",
            "<Herobrine> skill issue",
            "<Herobrine> L + ratio",
            "<Herobrine> bro r u even trin",
            "<Herobrine> i hope your not recording rn",
            "<Herobrine> what the fuck was thatr",
            "<Herobrine> plese touch some grass",
            "<Herobrine> lack of female companions?",
            "<Herobrine> {USERNAME} im watching u",
            "<Herobrine> y r u rap battling me again??",
            "<Herobrine> Y U NO GOOD",
            "<Herobrine> youre life is meaningless,\nyou serve zero purpose",
            "<Herobrine> noob",
            "<Herobrine> My mom can do better than you,\nand she just had tit surgery.",
            "<Herobrine> bruj, you died thats so sus 😆 😆 😆 😆 😆",
            "<Herobrine> I gave you your final warning.",
            "<Herobrine> there is really no escape.\ni'm gonna keep killing you.",
            "<Herobrine> i fucked your mom last night, and now i've fucked you"
        ],
        "alex" => [
            "<Alex> this is certainly not how you impress a lady",
            "<Alex> uninstall",
            "<Alex> y r u even plaing this mod",
            "<Alex> another bozo on teh list",
            "<Alex> imagine being beaten by a rotten corpse kekekek",
            "<Alex> FC when?",
            "<Alex> gg bozo",
            "<Alex> even the creators think u suk",
            "<Alex> common alex W",
            "<Alex> common bf L",
            "<Alex> ._.",
            "<Alex> I did not get 1 Million views for nothing.",
            "<Alex> I'm always watching... even when you die..",
            "<Alex> why'd you even try."
        ],
        "voidboi" => [
            "<NUll> Waste of my time.",
            "<NUll> How did you even get down here?",
            "<NUll> You and your mods need to leave.",
            "<NUll> What do you mean my voice sounds familiar?",
            "<NUll> Where's my body?\nYou're falling in it.",
            "<NUll> And you say you have a girlfriend?\nI dont see it.",
            "<NUll> I don't need a form to beat you.",
            "<NUll> Bro? For Real? On God? Just Like That?",
            "<NUll> Looks like you were the one who fell off.",
            "<NUll> You dont even know what the Dev Team went though making this mod\nbe grateful your able to try again.",
            "<NUll> Are you aware where you are rn?",
        ],
        "brina" => [
            "<Brina> You still here?... hello?",
            "<Brina> I thought you were really good at rapping : (",
            "<Brina> Im based off some guy, but we keep that under wraps.",
            "<Brina> I won!",
            "<Brina> your no fun! *puffs*"
        ],
        "steev" => [
            "<steev> LMAO NOOB",
            "<steev> Rekt",
            "<steev> Clipped like a bot",
            "<steev> *laughs and points*",
            "<steev> fuck yo homie dead"
        ],
        "quandale-sonic" => [
            "<Sonic.exe> Too easy!",
            "<Sonic.exe> Piece of cake!",
            "<Sonic.exe> Imagine Dying......Wait.",
            "<Sonic.exe> GET OVRT HERE TAILS!",
            "<Sonic.exe> aren't you a god or something?"
        ],
        "slenderman" => [
            "<Slenderman> Too easy!",
            "<Slenderman> I cummed in your mom",
        ],
        "oldroot" => [
            "<OldRoot> Get out.",
            "<OldRoot> Turn back now.",
        ],
    ];

    public static function getDeathQuote(char:String):String {
        if (deathQuotes.exists(char)) {
            var arr = deathQuotes.get(char);
            return fix(arr[FlxG.random.int(0, arr.length - 1)]);
        }

        return '';
    }

    public static function fix(str:String):String {
        var a:Array<Array<String>> = [
            ["'", "`"],
            ["-", "~"],
            ["USERNAME", Sys.getEnv("USERNAME")]
        ];
        for (i in a) {
            str = str.replace('{${i[0]}}', i[1]);
        }
        return str;
    }
}
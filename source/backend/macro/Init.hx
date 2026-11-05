#if macro
package backend.macro;

import haxe.macro.Context;
import haxe.macro.Compiler;

class Init {
	static final scriptableClasses:Array<String> = [
		'openfl.events.EventDispatcher',
		'openfl.display.DisplayObject', 'openfl.display.DisplayObjectContainer', 'openfl.display.InteractiveObject', 'openfl.display.Sprite', 'openfl.display.Bitmap',
		
		'flixel.FlxBasic', 'flixel.FlxObject', 'flixel.FlxSprite', 'flixel.FlxStrip', 'flixel.FlxState', 'flixel.FlxSubState', 'flixel.text.FlxText',
		'flixel.system.ui.FlxSoundTray', 'flixel.addons.ui.FlxUIState', 'flixel.addons.transition.FlxTransitionableState',
		
		'backend.MusicBeatState', 'backend.MusicBeatSubstate',
		
		'animate.FlxAnimate'
	];
	static final scriptablePackages:Array<String> = [
		'flixel.group', 'flixel.effects',
		
		'objects'
	];
	
	public static macro function includeClasses():Void {
		Compiler.include('flixel', true, ['flixel.addons.nape', 'flixel.addons.editors.spine', 'flixel.system.macros']);
		Compiler.include('haxe', true, ['haxe.atomic', 'haxe.macro']);
		Compiler.include('shaders', true);
		
		if (Context.defined('sys') && Context.defined('SCRIPTS_ALLOWED')) {
			if (Context.defined('hl')) {
				Compiler.include('sys', true, ['sys.db', 'sys.ssl', 'sys.net']);
			} else {
				Compiler.include('sys', true);
			}
		}
	}
	
	public static macro function init():Void {
		Compiler.addMetadata('@:build(backend.macro.Scripting.ExtraDataMacro.build())', 'flixel.FlxBasic');
		Compiler.addMetadata('@:build(backend.macro.Flixel.FlixelMacro.buildFlxText())', 'flixel.text.FlxText');
	}
	
	// hscript
	public static macro function includeScriptableClasses():Void {
		Compiler.addGlobalMetadata('flixel', '@:build(insanity.macro.Patcher.patch())');
		Compiler.addGlobalMetadata('flixel.group', '@:build(insanity.macro.Patcher.patch(true))');
		Compiler.addGlobalMetadata('flixel.effects', '@:build(insanity.macro.Patcher.patch(true))');
		
		Compiler.addGlobalMetadata('', '@:build(insanity.macro.ScriptableMacro.buildScriptable([], [], (cls) -> {
			for (ccls in ["${scriptableClasses.join('", "')}"]) if (ccls == cls) return true;
			for (ccls in ["${scriptablePackages.join('", "')}"]) if (cls.indexOf(ccls) == 0) return true;
			return false;
		}))');
	}
	
	public static macro function includeScriptedAbstracts():Void {
		Compiler.addGlobalMetadata('', '@:build(insanity.macro.AbstractMacro.build())');
	}
}
#end

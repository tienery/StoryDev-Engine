package ;

import openfl.Assets;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

class Sm
{
	private static var _channels:Array<SoundChannel> = [];

	public function Sm()
	{

	}

	public static function playSound(soundName:String, channelNumber:Int, loops:Int):Void
	{
		_channels[channelNumber] = Assets.getSound("a/sound/" + soundName, true).play(0, loops == -1 ? 999999 : loops);
	}

	public static function stopChannel(channelNumber:Int):Void
	{
		if (_channels[channelNumber] != null) _channels[channelNumber].stop();
	}

	public static function modifyChannel(channelNumber:Int, volume:Int, pan:Int):Void
	{
		var trans:SoundTransform = new SoundTransform(volume / 100, pan / 100);
		if (_channels[channelNumber] != null) _channels[channelNumber].soundTransform = trans;
	}
}
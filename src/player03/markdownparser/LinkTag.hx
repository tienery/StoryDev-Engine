package player03.markdownparser;

import openfl.text.TextFormat;

/**
 * @author Joseph Cloutier
 */
class LinkTag extends MarkdownTag {
	public static inline function getTextFormat(color:Int = 0x0000FF):TextFormat {
		return new TextFormat(null, null, color, null, null, true);
	}
	
	public static inline var PATTERN:String = "\\[(.+?)\\]\\((.+?)\\)";
	
	public function new(linkColor:Int = 0x0000FF) {
		super("link", PATTERN, getTextFormat(linkColor), 1);
	}
	
	public override function getFormatForMatch():TextFormat {
		var format:TextFormat = getTextFormat(this.format.color);
		format.url = matcher.matched(2);
		return format;
	}
}
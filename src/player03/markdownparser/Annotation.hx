package player03.markdownparser;

import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * @author Joseph Cloutier
 */
class Annotation {
	public var tagName:String;
	public var format:TextFormat;
	public var beginIndex:Int;
	public var endIndex:Int;
	public var extraData:Array<String>;
	
	public function new(matchedTag:MarkdownTag, offset:Int = 0) {
		tagName = matchedTag.name;
		format = matchedTag.getFormatForMatch();
		beginIndex = matchedTag.matcher.matchedPos().pos + offset;
		endIndex = beginIndex + matchedTag.matcher.matched(1).length;
		
		if(matchedTag.extraGroups > 0) {
			extraData = [for(i in 2...(matchedTag.extraGroups + 2))
							matchedTag.matcher.matched(i)];
		}
	}
	
	public inline function applyFormat(textField:TextField) {
		textField.setTextFormat(format, beginIndex, endIndex);
	}
}
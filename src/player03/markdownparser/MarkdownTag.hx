package player03.markdownparser;

import openfl.text.TextFormat;

/**
 * @author Joseph Cloutier
 */
class MarkdownTag {
	public var name:String;
	public var matcher:EReg;
	public var format:TextFormat;
	public var extraGroups:Int;
	
	public function new(name:String, pattern:String, format:TextFormat, extraGroups:Int = 0) {
		this.name = name;
		matcher = new EReg(pattern, "i");
		this.format = format;
		this.extraGroups = extraGroups;
	}
	
	public function getFormatForMatch():TextFormat {
		return format;
	}
}
package player03.markdownparser;

import openfl.text.TextFormat;
import game.Fonts;

/**
 * @author Joseph Cloutier
 */
class MarkdownParser {
	public static var defaultTags:Array<MarkdownTag> = [
		new MarkdownTag("bold", "\\*\\*(.+)\\*\\*", new TextFormat(null, null, null, true)),
		new MarkdownTag("bold", "__(.+)__", new TextFormat(null, null, null, true)),
		new MarkdownTag("italics", "_(.+)_", new TextFormat(null, null, null, null, true)),
		new MarkdownTag("italics", "\\*(.+)\\*", new TextFormat(null, null, null, null, true))
	];
	
	private var tags:Array<MarkdownTag>;
	
	public function new(tags:Array<MarkdownTag> = null) {
		if(tags == null) {
			this.tags = defaultTags;
		} else {
			this.tags = tags;
		}
	}
	
	public function parse(text:String):ParserResult {
		var annotations:Array<Annotation> = [];
		return new ParserResult(parse2(text, annotations, 0), annotations);
	}
	
	private function parse2(text:String, annotations:Array<Annotation>, offset:Int):String {
		var firstTag:MarkdownTag = null;
		var tagIndex:Int = 0xFFFFFF; //A large number, nothing more.
		
		//Find the first matching tag.
		for(tag in tags) {
			if(tag.matcher.match(text)
					&& tag.matcher.matchedPos().pos < tagIndex) {
				firstTag = tag;
				tagIndex = tag.matcher.matchedPos().pos;
			}
		}
		
		if(firstTag != null) {
			var annotation:Annotation = new Annotation(firstTag, offset);
			annotations.push(annotation);
			
			var left:String = firstTag.matcher.matchedLeft();
			var middle:String = firstTag.matcher.matched(1);
			var right:String = firstTag.matcher.matchedRight();
			
			//Recursively parse the text in the matched tag.
			middle = parse2(middle, annotations, offset + left.length);
			
			//The recursive call above may have shortened the text.
			annotation.endIndex = annotation.beginIndex + middle.length;
			
			//Recursively parse the text after the matched tag.
			right = parse2(right, annotations, offset + left.length + middle.length);
			
			return left + middle + right;
		}
		
		return text;
	}
}
package player03.markdownparser;

import openfl.text.TextField;

/**
 * @author Joseph Cloutier
 */
class ParserResult {
	public var text:String;
	public var annotations:Array<Annotation>;
	
	public function new(text:String, annotations:Array<Annotation>) {
		this.text = text;
		this.annotations = annotations;
	}
	
	public function apply(textField:TextField):Void {
		textField.text = text;
		for(annotation in annotations) {
			annotation.applyFormat(textField);
		}
	}
}
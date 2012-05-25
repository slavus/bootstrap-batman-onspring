package net.slavus.web.wro;

import java.io.InputStream;

import ro.isdc.wro.extensions.processor.css.LessCssProcessor;
import ro.isdc.wro.extensions.processor.support.less.LessCss;

public class ExtendedLessCssProcessor extends LessCssProcessor {

	@Override
	protected LessCss newLessCss() {
		return  new LessCss() {
			@Override
			protected InputStream getScriptAsStream() {
				return this.getClass().getResourceAsStream(
						"/utils/less-1.3.0.min.js");
			}
		};
	}

}

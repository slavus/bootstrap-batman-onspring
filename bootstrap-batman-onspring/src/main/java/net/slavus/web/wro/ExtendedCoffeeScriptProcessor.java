package net.slavus.web.wro;

import java.io.InputStream;

import ro.isdc.wro.extensions.processor.js.CoffeeScriptProcessor;
import ro.isdc.wro.extensions.processor.support.coffeescript.CoffeeScript;

public class ExtendedCoffeeScriptProcessor extends CoffeeScriptProcessor {
	@Override
	protected CoffeeScript newCoffeeScript() {
		return new CoffeeScript() {
			@Override
			protected InputStream getCoffeeScriptAsStream() {
				return this.getClass().getResourceAsStream(
						"/utils/coffee-script.js");
			}
		};
	}


}

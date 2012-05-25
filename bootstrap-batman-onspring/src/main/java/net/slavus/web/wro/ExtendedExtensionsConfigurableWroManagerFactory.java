package net.slavus.web.wro;

import java.util.Map;

import ro.isdc.wro.extensions.manager.ExtensionsConfigurableWroManagerFactory;
import ro.isdc.wro.model.resource.processor.ResourcePostProcessor;
import ro.isdc.wro.model.resource.processor.ResourcePreProcessor;
import ro.isdc.wro.model.resource.processor.impl.ExtensionsAwareProcessorDecorator;

public class ExtendedExtensionsConfigurableWroManagerFactory extends
		ExtensionsConfigurableWroManagerFactory {

	@Override
	protected void contributePostProcessors(
			final Map<String, ResourcePostProcessor> map) {
		ExtendedExtensionsConfigurableWroManagerFactory
				.populateMapWithExtensionsPostProcessors(map);
		map.put("extendedLessCss", new ExtendedLessCssProcessor());
		// map.put("extendedCoffeeScript", new ExtendedCoffeeScriptProcessor());

	}

	@Override
	protected void contributePreProcessors(
			final Map<String, ResourcePreProcessor> map) {
		ExtendedExtensionsConfigurableWroManagerFactory
				.populateMapWithExtensionsProcessors(map);

		ResourcePreProcessor coffeeScriptProcessor = ExtensionsAwareProcessorDecorator
				.decorate(new ExtendedCoffeeScriptProcessor()).addExtension(
						"coffee");
		ResourcePreProcessor lessProcessor = ExtensionsAwareProcessorDecorator
				.decorate(new ExtendedLessCssProcessor()).addExtension("less");

		map.put("extendedLessCss", lessProcessor);
		map.put("extendedCoffeeScript", coffeeScriptProcessor);
	}
}

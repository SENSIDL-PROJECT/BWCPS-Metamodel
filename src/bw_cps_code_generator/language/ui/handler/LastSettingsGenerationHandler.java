package bw_cps_code_generator.language.ui.handler;

import java.io.FileNotFoundException;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.core.commands.IHandler;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.swt.widgets.Shell;

import bw_cps_code_generator.language.ui.exception.NoBwcpsFileException;

public class LastSettingsGenerationHandler extends AbstractHandler implements IHandler {

	@Override
	public Object execute(ExecutionEvent event) throws ExecutionException {
		// Get input from saved settings
		String modelPath = SettingsHandler.loadModelPathSettings();
		String path = SettingsHandler.loadPathSettings();
		String language = SettingsHandler.loadLanguageSettings();
		
		// Make Paths absolute
		if (modelPath.startsWith("platform:/resource")) {
			modelPath = modelPath.replace("platform:/resource",
					ResourcesPlugin.getWorkspace().getRoot().getLocation().toString());
		}
		if (path.startsWith("platform:/resource")) {
			path = path.replace("platform:/resource",
					ResourcesPlugin.getWorkspace().getRoot().getLocation().toString());
		}
		
		// Exception handling to give user feedback
		ErrorDialogHandler errorHandler = new ErrorDialogHandler();
		try {
			// start the generator with the GenerationHandler
			GenerationHandler.generate(path, modelPath, language, null);
			MessageDialog.openInformation(new Shell(), "Info", "The code was successfully generated");
		} catch (FileNotFoundException ex) {
			errorHandler.execute(new Shell(), ex);
		} catch (NoBwcpsFileException ex) {
			errorHandler.execute(new Shell(), ex);
		} catch (Exception ex) {
			errorHandler.execute(new Shell(), ex);
		}

		return null;
	}

}

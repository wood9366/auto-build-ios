using UnityEngine;
using System.Collections;
using UnityEditor;
using System.Collections.Generic;

public class CustomBuild {
	static void BuildIOS() {
		string[] args = System.Environment.GetCommandLineArgs();

		Debug.Log("============================ Build IOS ============================");

		string outputDir = getArg(args, "o");
		string appId = getArg(args, "appid", PlayerSettings.bundleIdentifier);
		string appName = getArg(args, "name", PlayerSettings.productName);

		Debug.Log("Output Directory: " + outputDir);
		Debug.Log("App ID: " + appId);
		Debug.Log("App Name: " + appName);

		if (outputDir != null) {
			PlayerSettings.bundleIdentifier = appId;
			PlayerSettings.productName = appName;

			string[] scenes = getScenes();

			printScenes(scenes);

			BuildPipeline.BuildPlayer(scenes, outputDir, BuildTarget.iOS, BuildOptions.None);
		} else {
			Debug.Log("Fail, must specific output dir");
		}

		Debug.Log("========================= Build IOS Done ===========================");
	}

	static void printScenes(string[] scenes) {
		string scenesStr = "BuildScenes:\n";

		foreach (string scene in scenes) {
			scenesStr += "  " + scene + "\n";
		}
		
		Debug.Log(scenesStr);
	}

	static string[] getScenes() {
		List<string> scenes = new List<string>();

		foreach (EditorBuildSettingsScene scene in EditorBuildSettings.scenes) {
			if (scene.enabled) {
				scenes.Add(scene.path);
			}
		}

		return scenes.ToArray();
	}

	static string getArg(string[] args, string name, string def = null) {
		string arg = def;

		for (int i = 0; i < args.Length; i++) {
			if (args[i] == "-" + name) {
				if (i + 1 < args.Length) {
					arg = args[i+1];
					break;
				}
			}
		}

		return arg;
	}
}

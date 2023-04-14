# Issue Details


## Update 3
The last commit demonstrates that the `UIWindow.didBecomeHiddenNotification` notification is never called when the user closes the AUv3 window in Logic. The `UIWindow.didBecomeVisibleNotification` is only called once when opening the AUv3 window for the first time.

## Update 2

The last commit demonstrates the isHidden remains false even after the window is closed.

Additionally, I did a separate investigation on the `detecting_plug-in_closure_nsviewcontroller` branch, where I used the original code, which is macOS native code (i.e. NOT MacCatalyst), and it appears that viewDidAppear and viewDidDisappear is called every time plug-in windows is open and closed in Logic Pro. In this scenario, AUViewController is a subclass of NSViewController.

My conclusion is that a subclass of AUViewController when used in a MacCatalyst AUv3 plug-in doesn't receive viewWill/DidAppear/Disappear callbacks. However, when it's a pure macOS AUv3 then it works as expected. And things work correctly on iOS (as previously mentioned).

## Update

The latest commits adds a way of checking if AU's main view's superview or window goes away after user closes the AU window in Logic. They don't seem. The video `IssueDetails\LogicPro-superview-window.mov` demonstrates this. When closed it still logs information about the superview and window.

## Description

What API should an Audio Unit v3 (AUv3) plug-in be using to figure out whether its UI is being displayed to the user or if it's hidden? My plug-in displays a lot of animation in its UI, and if the user has multiple instances of my plug-in in a session it will use a lot of CPU. As it will needlessly be refreshing its UI. I found, on iOS, AUViewController's viewWillDisapper and viewDidDisappear get called but not on macOS.

## Steps to reproduce it

Visit the following link for the code and screen recordings: https://github.com/Nikolozi/AudioUnitV3Experiments/tree/detecting_plug-in_window_closure

On this branch, I have modified the AUv3FilterExtension plug-in to log when AUViewController's view[Will/Did][Appear/Disappear] methods are called. On macOS, in Logic Pro 10.7.7 and Ableton Live 11.2.10, the viewWillAppear and viewDidAppear methods are called once after the AUv3FilterExtension plug-in instantiation and the Disappear methods are never called.

On iOS, in GarageBand and AUM, all 4 methods are called every time I open and close the AUv3FilterExtension window.

So, the main question is, on iOS I can use the VC's Appear/Disappear methods to know when the plug-in is shown or hidden to the user. What approach should I take on macOS? Since this behaviour is also happening in Ableton Live, I assume this is not a Logic Pro bug, but maybe this is how things work on macOS. But I imagine there has to be a way for an audio unit to know whether its interface is being displayed on the screen or not.

I'm also providing screen recordings demonstrating the above issue. The videos can be found in the `IssueDetails` folder. The files are `IssueDetails\LogicPro.mov` and `IssueDetails\GarageBand.mp4`.

# What's this repo about?

This is a fork of Apple's [CreatingCustomAudioEffects](https://developer.apple.com/documentation/audiotoolbox/audio_unit_v3_plug-ins/creating_custom_audio_effects) sample code. The primary use case for this repo is to demonstrate possible bugs on Apple platforms or in Logic Pro / GarageBand.

Check the branches to see details of the various issues.

## Compiling
To compile the code, delete `#include "DEVELOPMENT_TEAM.xcconfig"` line in *SampleCode.xcconfig* file and replace it with `DEVELOPMENT_TEAM = XXXXXXXXXX` where `XXXXXXXXXX` is your Apple Developer Team ID.

## Running auval on macOS

For MIDI Plug-in: `auval -v aumi midi Demo`

## Future Plans

Can't be sure.
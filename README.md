# Orange trust badge iOS Reference

![Orange trust badge : your privacy first](https://github.com/Orange-OpenSource/orange-trust-badge-ios/raw/master/logo.png)

With the Orange trust badge, aka "Badge de confiance", give transparent informations and user control on personal data and help users to identify if your application has any sensitive features.

## Features
Orange trust badge displays how are handled the following device permissions :

- Location
- Contacts
- Photos Library
- Media
- Usage data
- Calendar
- Reminders
- Microphone
- Bluetooth Sharing
- Microphone
- Speech Recognition
- Health
- Homekit
- Motion Activity & Fitness

It can also displays the following application data :

- Notifications
- Identity
- Account Informations
- Data usage
- Advertising
- History

It also :

- Works on iPhone and iPad using Autolayout (iPad Multitasking supported)
- Localized in 2 languages (English, French)
- Written in Swift 4.0 but works in Objective-C or Swift based Projects
- API hooks
- UI Customization

## Requirements

- iOS 9.0+
- Xcode 9.4.1+
- CocoaPods 1.5.3+

## Bug tracker

- If you find any bugs, please submit a bug report through Github and/or a pull request.

## Example project
An example of integration is provided in OrangeTrustBadgeDemo project.

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8**

### <a name="cocoapods"></a>CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.0.1+ is required to build OrangeTrustBadge.

To integrate OrangeTrustBadge into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '9.0'
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

pod 'OrangeTrustBadge'
```

In a post_install directive of your Podfile configure the **OTHER\_SWIFT\_FLAGS** with **ONLY** what your app need.
See the table in the section named [Configure OrangeTrustBage build](#configure).

eg: If your app needs the HealthKit permission add the line 
>config.build_settings['OTHER_SWIFT_FLAGS'] << '-DHEALTHKIT'

if not,  **DO NOT ADD IT**.

```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2'
      config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)']
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DCORELOCATION'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DPHOTOS'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DCONTACTS'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DMEDIAPLAYER'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DCAMERA'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DEVENTKIT'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DBLUETOOTH'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DSPEECH'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DUSERNOTIFICATIONS'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DMOTION'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DHEALTHKIT'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DHOMEKIT'
    end
  end
end
```
Then, run the following command:

```bash
$ pod install
```
### <a name="carthage"></a>Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with Homebrew using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate OrangeTrustBadge into your Xcode project using Carthage, specify it in your Cartfile:

>github "Orange-OpenSource/orange-trust-badge-ios" ~> 1.1

Run the following commands to configure then build the framework. Drag the built OrangeTrustBadge.framework into your Xcode project.

```bash
$ carthage checkout orange-trust-badge-ios
$ cd Carthage/Checkouts/orange-trust-badge-ios/
$ ./Scripts/configure.sh
$ cd -
$ carthage build orange-trust-badge-ios
```

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate OrangeTrustBadge into your project manually.

#### Embedded Framework
- Clone OrangeTrustBadge Repository by typing in your Terminal
```bash
$ git clone https://github.com/Orange-OpenSource/orange-trust-badge-ios.git
```
- Go into `orange-trust-badge-ios` directory by typing in Terminal
```bash
$ cd orange-trust-badge-ios/
```
- Then, run the following command:
```bash
$ pod install
```
- You should now be able to open `OrangeTrustBadge.xcworkspace` located at the same level of `OrangeTrustBadge.xcodeproj`.
- Now we will build a FAT dynamic framework containing all architectures to make it run on Simulator as well as Real Devices (ARM,ARM64,i386 and x86_64). To do that, please select the appropriate target named `build-fat-framework` and start archiving it with `Product > Archive` (important to run "Archive" and not just Build/Run the target).
- Once finished, the Finder should have opened a window containing a fresh build of the framework named `OrangeTrustBadge.framework`

In your own Xcode project :  
- In the tab bar at the top of that window, open the "General" panel.
- Drag and drop generated Framework into the "Embedded Binaries" section.
- If your project is not a Swift Project, go into "Build Settings" tab and find the parameter EMBEDDED_CONTENT_CONTAINS_SWIFT and set it to YES.
- Finally, find update the parameter value of "ENABLE_BITCODE" to "NO"

> The `OrangeTrustBadge.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

- Don't forget to add a build phase to strip simulators architectures in case of a Release to avoid any issues when uploading your app to the AppStore. To do that, simply go into `Build Phases` Tab of your project, add a `New Run Script Phase` and put the script above into the textfield located under "/bin/sh". This new Run Script phase should be placed at the end of the phases list.

```bash
OUTPUT_DIR="${DWARF_DSYM_FOLDER_PATH}/strip"
rm -rf "$OUTPUT_DIR"
mkdir "$OUTPUT_DIR"

INPUT_FRAMEWORK_BINARY=`find ${DWARF_DSYM_FOLDER_PATH}/${FRAMEWORKS_FOLDER_PATH}/ -type f -name OrangeTrustBadge`
OUTPUT_FRAMEWORK_BINARY="${OUTPUT_DIR}/OrangeTrustBadge"

# remove simulator arch from the release
if [ "$CONFIGURATION" == "Release" ]; then
    if [  "$CURRENT_ARCH" != "x86_64" ]; then

        lipo "${INPUT_FRAMEWORK_BINARY}" -verify_arch x86_64
        if [ $? == 0 ] ; then
            REMOVE_ARCHS="-remove x86_64"
            arch_found=true
        fi

        lipo "${INPUT_FRAMEWORK_BINARY}" -verify_arch i386
        if [ $? == 0 ] ; then
            REMOVE_ARCHS="${REMOVE_ARCHS} -remove i386"
            arch_found=true
        fi

        if [ "$arch_found" == "true" ]; then
            lipo ${REMOVE_ARCHS} "${INPUT_FRAMEWORK_BINARY}" -output "${OUTPUT_FRAMEWORK_BINARY}"

            cp -f "${OUTPUT_FRAMEWORK_BINARY}" "${INPUT_FRAMEWORK_BINARY}"
            rm -rf "$OUTPUT_DIR"

            codesign --force --sign "${EXPANDED_CODE_SIGN_IDENTITY}" --timestamp=none --verbose `dirname ${INPUT_FRAMEWORK_BINARY}`
        fi

    fi
fi
```

## <a name="configure"></a>Configure OrangeTrustBage build
In order to pass the App Store validation, you must declare only the permissions that your app effectively use. Otherwise Apple may reject your app.

So OrangeTrustBadge compiles and uses only the needed frameworks by setting the **OTHER\_SWIFT\_FLAGS** build setting.

| COMPILE FLAG  | FRAMEWORK | PERMISSION     |
| :---        |    :----:   |          ---: |
|CORELOCATION | CoreLocation| Location
|PHOTOS| Photos | Photos | Photos Library
|CONTACTS| EventKit | Calendar, Reminders
|MEDIAPLAYER | MediaPlayer | Media
|CAMERA | MediaPlayer | Media
|EVENTKIT | EventKit | Calendar, Reminders
|BLUETOOTH | CoreBluetooth | Bluetooth Sharing
|SPEECH | Speech | Speech Recognition
|USERNOTIFICATIONS | UserNotifications | Notifications
|MOTION | CoreMotion | Motion Activity & Fitness
|HEALTHKIT | HeakthKit | HealthKit
|HOMEKIT | HomeKit | HomeKit

##### Configure the badge compilation for Cocoapods
If you use Cocoapods, use a ***post_install directive*** to configure the badge. See the section [Cocoapods](#cocoapods) above.

##### Configure the badge compilation for Carthage
If you use Carthage, The script name **configure.sh** provided with OrangeTrustBadge will be automaticaly configured the framework. What you have defined in the ***InfoPlist.strings*** of your project will be used to set the **OTHER\_SWIFT\_FLAGS** build setting with the right values.

eg: If you define **NSContactsUsageDescription** in the InfoPlist.strings of your project then OrangeTrustBadge will add the flag ```-DCONTACTS``` in the **OTHER\_SWIFT\_FLAGS** build setting.
See the section [Carthage](#carthage) above.


Here is an example of what your app InfoPlist.string file would look like.

```
"NSSpeechRecognitionUsageDescription" = "This application has requested access to speech recognition. Speech recognition sends recorded voice to Apple to process your requests.";
"NSAppleMusicUsageDescription" = "This application has requested access to your music activity and your media library.";
"NSBluetoothPeripheralUsageDescription" = "This application has the ability to share data via Bluetooth.";
"NSCalendarsUsageDescription" = "This application can use the calendar information on your device, including consultation of recorded events.";
"NSCameraUsageDescription" = "This application can use the camera of your device. The camera access allows this application to take pictures and record video.";
"NSContactsUsageDescription" = "This application can access, add and / or change your phone contacts.";
"NSHealthShareUsageDescription" = "This application has requested access to your health data.";
"NSHealthUpdateUsageDescription" = "This application has requested access to your health data.";
"NSHomeKitUsageDescription" = "This application has requested access to your home data.";
"NSLocationAlwaysAndWhenInUseUsageDescription" = "With your permission, Location Services allows this application to use information from cellular, Wi-Fi, Global Positioning System (GPS) networks, and Bluetooth to determine your approximate location.";
"NSLocationAlwaysUsageDescription" = "With your permission, Location Services allows this application to use information from cellular, Wi-Fi, Global Positioning System (GPS) networks, and Bluetooth to determine your approximate location.";
"NSLocationWhenInUseUsageDescription" = "With your permission, Location Services allows this application to use information from cellular, Wi-Fi, Global Positioning System (GPS) networks, and Bluetooth to determine your approximate location.";
"NSMicrophoneUsageDescription" = "This application can use the microphone of your device. The access to micro allows the application to record audio content.";
"NSMotionUsageDescription" = "Fitness and health tracking allows apps to access sensor data, including body movement, steps count, and more.";
"NSPhotoLibraryUsageDescription" = "This application can use photos stored on your device. This permission allows the application to read, edit or delete stored files.";
"NSRemindersUsageDescription" = "This application can use the reminders information on your device, including consultation of recorded events.";
```


And that's it!
---

## Usage

### Initialization of the SDK

**In swift**

```swift
import OrangeTrustBadge

func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
	TrustBadge.with(TrustBadgeConfig())
	return true
}
```
**or in Objective-C**

```objc

#import "OrangeTrustBadge-Swift.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[TrustBadge with:[[TrustBadgeConfig alloc] init]];
	return YES;
}
```

### Add OrangeTrustBadge UI in your storyboard

#### Using code (available on iOS 9 and later)
- Create an IBAction connected to one of your interface element (e.g a button, a cell etc...).
- Instanciate OrangeTrustBadge storyboard with the following lines :

**Present the badge modally**

```swift
import OrangeTrustBadge

@IBAction func onButtonClicked(){
	let storyboard = UIStoryboard(name: "OrangeTrustBadge", bundle: NSBundle(forClass: TrustBadge.self))
	if let viewController = storyboard.instantiateInitialViewController() {
    	self.present(viewController, animated: true, completion: nil)
    }
}
```
**Push the badge**

```swift
import OrangeTrustBadge

@IBAction func onButtonClicked(){
	let storyboard = UIStoryboard(name: "OrangeTrustBadge", bundle: NSBundle(forClass: TrustBadge.self))
	let viewController = storyboard.instantiateViewController(withIdentifier: "LandingController")
    self.navigationController?.pushViewController(viewController, animated: true)
}
```


That's it !

#### Using Storyboard References (available on iOS9 and later)
- Open your storyboard file and add a Storyboard reference object in it
- Click on newly created Storyboard Reference and go into Attribute inspector on the right panel
- In Storyboard field, select `OrangeTrustBadge`
- In Bundle field, type `org.cocoapods.OrangeTrustBadge`
- Finally, create a segue from the appropriate button or cell in your app and this Storyboard Reference (Some segue types might be unavailable since this component is using UISplitViewController - Try "Present Modally" to start)

![inspector](https://github.com/Orange-OpenSource/orange-trust-badge-ios/raw/master/inspector.png)

That's it !

### Add custom view to the badge
You may have to add  some informations related to your app in the badge section.
Orange Trust Badge allow you to provide a view controller wich will be displayed as a custom view.

To provide this view controller, you must implement two methods of `TrustBadgeDelegate` protocol.

    /// If this method returns true, the landing page will displayed a cell that allows to access
    //// to this view controller.
    @objc optional func shouldDisplayCustomViewController() -> Bool
    
    
    /// Implement this method to return a viewController to displayed for the CustomMenuCell
    @objc optional func viewController(at indexPath: IndexPath) -> UIViewController


To allow the user to access you custom view controller, TrustBadge will add a an entry in LandingController.
The title and the subtitle of this entry (UITableViewCell) must be configured with the following Localizable.string keys.

Title

`
"landing-custom-title" = "Customizable content";
`

Subtitle

`
"landing-custom-content" = "Find out other apps that have adopted the Trust Badge";
`

### Add localization support

In order to localize properly the UI, OrangeTrustBadge is using standard iOS mechanisms.
Concretly the SDK will take the current language setup on user's phone unless your app support this localization. English will be taken by Default.

To add a localization support, go to Project Level and add appropriate localization in "Info" Tab.

You can override every visible text using your own Localizable.strings file. To know which key you need to override, please see SDK 's Localization file.


## Customization

OrangeTrustBadge can be customized in various ways

### Main / Other Elements View
In this View are displayed two pre-defined sections showing TrustBadge Elements and their underlying status. Although it is required to have at least one item in the first section, you can fully customize the different sections using PreDefined or Custom Elements.

- A PreDefinedElement that is automagically setup for common cases

Note: If desired, you will be able to also customize the behavior of PreDefinedElements. Be sure to disengage automatic setup by setting the property shouldBeAutoConfigured to false. (e.g : aPreDefinedElement.shouldBeAutoConfigured = false)

**In swift**

```swift
let advertisingElement = PreDefinedElement(type: .advertising)
advertisingElement.statusClosure = {() in return true}
config.applicationData.append(advertisingElement)
```

### Terms and Conditions View

In this section you will find Standardized Terms ans conditions that can be replaced / updated according to your needs through Localization.
If you want to add a section in this View, you just have to add a new Term instance :

**In swift**

```swift
let customTerm = Term(type: .Custom, titleKey: "term-custom-title", contentKey: "term-custom-content")
config.terms.append(customTerm)
```

You can even display Dailymotion videos explaining your policies using .Video TermType. Please fill in "contentKey" with the video ID from Dailymotion (ex: x3xwu6v ).

### CSS and HTLM tokens

TrustBadgeElements and Terms descriptions may contains HTML code, with the following restriction :

- UTF-8 encoded
- no external resource (image, css, ...) can be used

When HTML is possible, there are 2 cases

- Full HTML : you must provide a HTML code WITH `<html>` and `<body>` tags
- Partial HTML : you must provide a HTML code WITHOUT `<html>` and `<body>` tags

Descriptions should include a stylesheet named $$cssStylesheet$$ and format the text using h1, h2, p and `<span class="p">`.
You can provide to OrangeTrustBadge your own CSS file by placing a file named style.css in your application bundle.

**In HTML**

```html
<!DOCTYPE html>
<html>
<head>
<meta content="text/html; charset=utf-8" http-equiv="content-type">
<style type="text/css">$$cssStylesheet$$</style>
</meta>
</head>
<body>
<h1>Aide</h1>
<p>Si besoin, votre application met à disposition cette adresse mail pour répondre à vos questions :</p>
<span class="p">
<!-- span.p is used for last paragraph, otherwise layount is broken-->
foo.bar@example.com
</span>
</body>
</html>
```

Some tokens will be available over time, but for the moment you can only use $$applicationName$$, configurable by using the appName field of TrustBadgeConfig (Default : CFBundleDisplayName or CFBundleName of host app)


## App Transport Security

OrangeTrustBadge is not requesting anything on the network unless you include videos in the Terms section. Videos are hosted on Dailymotion.com and connections made to this service are compliant with ATS policies.  

## Credits

OrangeTrustBadge was made with love by Orange

### Security Disclosure

If you believe you have identified a security vulnerability with OrangeTrustBadge, you should report it as soon as possible on the bug tracker.

## License

OrangeTrustBadge
Copyright (C) 2016 - 2019 Orange

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

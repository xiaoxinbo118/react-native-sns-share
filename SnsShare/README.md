
# react-native-sns-share

## Getting started

`$ npm install react-native-sns-share --save`

### Mostly automatic installation

`$ react-native link react-native-sns-share`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-sns-share` and add `RNSnsShare.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNSnsShare.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.evan.sns.share.RNSnsSharePackage;` to the imports at the top of the file
  - Add `new RNSnsSharePackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-sns-share'
  	project(':react-native-sns-share').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-sns-share/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-sns-share')
  	```


## Usage
```javascript
import RNSnsShare from 'react-native-sns-share';

// TODO: What to do with the module?
RNSnsShare;
```
  
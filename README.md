# FastCapture
Free and Open Source screen capture app for Yosemite written in Swift.

Login with your Imgur account to have full access to your screenshots!

## Download
[Here!](https://github.com/franciscocgoncalves/FastCapture/raw/master/FastCapture.zip)

## Running the project
  1. Clone the repo: <code>git clone git@github.com:franciscocgoncalves/FastCapture.git</code>
  2. Enter the directory: <code>cd FastCapture</code>
  3. Install the dependencies: <code>pod install</code>
  4. Create file Keys.plist
  5. Go to [Imgur Keys](http://api.imgur.com/oauth2/addclient)
  7. Generate anonymous and authenticated with callback keys
  8. Add following keys to Keys.plist: <code>"anonymousClientId"</code>, <code>"authenticatedClientId"</code>, <code>"authenticatedSecret"</code>

## Installation
  If you get an error saying that I'm not an Identified Developer, please try to open the app with Alt+Click or follow [this]( https://support.apple.com/kb/PH14369?viewlocale=en_US&locale=pt_PT ) instructions.

## Usage
Hit Command-Shift-3 to take a screenshot of the screen.

Hit Command-Shift-4 to take a screenshot of a part of the screen.


## Issues

Please, be aware that there might be conflicts if you have another screen capture app running. On future updates I'll try to fix that.

When trying to login with Twitter, you might run into problems.
Cause: Twitter callback to Imgur is causing an [error](http://i.imgur.com/pX6DY2p.png).

Workaround:
Go to Imgur website login with Twitter and then hit the login button on Fast Capture.
Hit me up if you want to contribute or if you find any bug!

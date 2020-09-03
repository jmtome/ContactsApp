# Kin+Carta -  iOS Programming Challenge

Programming challenge used to assess skill level and problem-solving abilities. 

## Developer Comments

### At the end of this Markdown can be found a  GIF with the app functioning showing:

    No Internet-> Failed Fetch -> Internet Connection -> Successful Fetch 

With the corresponding Activity Indicators. 

### Note :

​	The simulation shown in the video was made using a 1Mbps network to be able to visualize the slow progression in the loading of the images from server.

### Development settings:

- [x] - **IDE:** Xcode 11.6
- [x] - **Target:** iOS/iPadOS 13.6
- [x] - **Orientations:** Portrait
- [x] - **UI Framework:** UIKit
- [x] - **UI Development:** Programmatic UI's with Autolayout
- [x] - **Third Party Frameworks:** No third party frameworks used

### Build Instructions
- [x] - Simply Start  ``` Kin+Carta.xcodeproj ```  project and **Build/Run**

### Attributions

- [x] - AppIcon:   [`Flat Icon ContactBook`](https://www.flaticon.com/free-icon/notebook_784856?term=address%20book&page=1&position=17)

- [x] - App Icon Maker: [`https://appicon.co/`](https://appicon.co/)

### Added Extra UI Features 

- [x] - Activity spinner to indicate initial network activity
- [x] - Pull to refresh in case internet is not working.


## Challenge Overview

Create an app that fetches JSON from the URL below and displays the results as shown in the screenshots on the next page. Your app should match the layout and formatting in the screenshots as closely as possible. (Colors and fonts do not need to be exact.) Please use the image assets provided.

```
https://s3.amazonaws.com/technical-challenge/v3/contacts.json
```

## Contacts View List

- [x] - The contacts should be grouped into two sections: Favorite Contacts and Other Contacts. Within each section, they should be sorted alphabetically by name.

- [x] - Each cell should display the associated contact’s small image. Use the included small placeholder image when appropriate.

- [x] - If a contact is a favorite, display a star emoji ( ⭐️ ) in front of their name. The emoji might look different
  depending on your platform.

- [x] - Tapping on a contact should take the user to the detail page for that contact.

## Contact Detail View

- [x] - Display the contact’s large image on this page. Use the included large placeholder image when appropriate. 

- [x] - If the contact does not have a particular piece of information, that row should not appear on their detail page. 

- [x] - In the top right corner, display a button that allows the user to favorite and unfavorite a contact. 

- [x] - Use the “Favorite True” and “Favorite False” assets provided.

- [x] - When the user favorites or unfavorites a contact, the home page should be updated to reflect that change.


## Other Notes 

- [x] - Your app only needs to support portrait orientation on a phone, but it should scale properly to different sized screens. You do not need to support landscape orientation or tablet devices

- [x] - You do not need to persist the data between sessions.

- [x] - Use any third party frameworks you’re comfortable including in your project.

- [x] - Use the latest non-beta version of your platform’s IDE (Xcode, Android Studio, etc.). - You only need to support the latest OS version of your platform.

- [x] - When you send your project back to your K+C recruiter, please outline the steps necessary to build and run your project.

# Video

<img src="Video.gif" width="500"/>

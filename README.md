# ESPNMarvelCover

======

## ESPNMarvelCover app documentation

This app is built using Xcode 13.0.

#### Flow  

This app consists of two screens, a data entry screen to imput comic IDs and an issue viewer to display the issue information.

Since dead-end requests are possible, data is loaded and confirmed before the user is sent to the issue display screen. This is in opposition to standard reactive design best practices, but it's considerably less annoying than triggering the transition animation when hunting for a comic.

#### Note on unusual data

Comics in the Marvel Database after the Iron Age and before Marvel Now tend not to have descriptions attached. However, since that portion of the database was imported directly from their distibutor databases, they do have the solicit text in the text blob. 

To handle as many comics in the database as possible, in the case of comics without a Description field, but with a solicit text, the solicit text is used as the description. In the case of comics with both (primarily event books from that era), the description field takes precedence. 

#### Libraries used

The only libraries used in the app were SwiftUI, Foundation, and CryptoKit.

## Devloper notes

#### How to add your developer keys

In Assets/AppSecret.json, edit that JSON document with your public and private API keys.

# Social_X Flutter App
Social_X is a Flutter app that allows users to log in or sign up using their email and password, Google, or Facebook accounts. Once logged in, users can access the home page, where they can view news articles from various sources. The app uses Firebase for authentication and cloud storage to store user information. It also integrates with external APIs, specifically the News API, to fetch and display news data.

## Features
Authentication: Users can log in or sign up using their email and password. Alternatively, they can use their Google or Facebook accounts for authentication.

<b>Home Page</b>: The home page displays a list of news articles fetched from the News API. Users can search for specific articles using the search bar.

<b>News Details</b>: Users can view detailed information about each news article by tapping on it. The news details include the title, source, publication date, and a read-more option for longer articles.

<b>Local Storage</b>: The app uses shared preferences to store news data locally, allowing users to access previously fetched news even when offline or with a slow internet connection.

<b>Logout</b>: Users can log out of their accounts to secure their access to the app.

## Dependencies Used
<b>firebase_core</b>: Handles the connection between Firebase and the Flutter app.<br>
<b>firebase_auth</b>: Provides authentication functionality using email and password.<br>
<b>country_picker</b>: Allows users to select their country code when entering their mobile number.<br>
<b>http</b>: Used for making API calls to fetch news data.<br>
<b>readmore</b>: Enhances the news article display with a "read more" feature for longer articles.<br>
<b>cloud_firestore</b>: Enables storing user information, such as name and mobile number, in the cloud.<br>
<b>provider</b>: Used for state management to access user email ID.<br>
<b>google_sign_in</b>: Provides Google sign-in functionality.<br>
<b>flutter_facebook_auth</b>: Allows users to log in using their Facebook accounts.<br>
<b>shared_preferences</b>: Used to store data locally in the app for offline access.<br>




## Getting Started
To get started with the Social_X app, follow these steps:
<ul>
<li>Clone this repository to your local machine.</li>
<li>Set up Firebase for your project and configure the necessary authentication providers (email/password, Google, Facebook).</li>
<li>Install the required dependencies by running flutter pub get.</li>
<li>Run the app using flutter run.</li>
</ul>


https://github.com/RohitMundhra123/socialX/assets/91062387/fc623226-5c55-4649-abdc-292448475367










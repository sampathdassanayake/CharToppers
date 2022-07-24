# CharToppers

This app uses Apples public data available at https://rss.applemarketingtools.com/

The app is built using swift and all UI's are built in code. Also the app does not use any third party libraries except for Realm.

The app uses the MVVM + repository + coordinator patterns. 

The view model binds the data to the UI. The repository handles the network call + storing data in realm. The app will always fetch data from the API on launch but it will bind the data in the realm datastore while the data is fetched. And once API call fetches data and updates the database, the notification token will result in the UI getting updated with the latest data. 

An extendable network client was created to handle the APi calls. 

Also added an ImageCache to prevent images being loaded over the network when user scrolls through the albums. 

The main feed uses a collection view and does pre-fetching to smoothen the scrolling and to download the images prior to the cell being shown.

Most of the code is self evident. 

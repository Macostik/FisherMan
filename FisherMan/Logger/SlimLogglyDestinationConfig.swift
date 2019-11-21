struct SlimLogglyConfig {
    // Replace your-loggly-api-key below with a "Customer Token"
    //(you can create a customer token in the Loggly UI)
    // Replace your-app-name below with a short name for your app
    //(no spaces or crazy characters). You can use this
    // tag in the Loggly UI to create Source Group for each app you have in Loggly.
    static let logglyUrlString = "http://logs-01.loggly.com/" +
        "inputs/588a8a56-9114-4b23-ab6d-825f6b2c3961/tag/heroku/"

    // Number of log entries in buffer before posting entries to Loggly.
    //Entries will also be posted when the user
    // exits the app.
    static let maxEntriesInBuffer = 5

    // Loglevel for the Loggly destination. Can be set to another level during runtime
    static var logglyLogLevel = LogLevel.info

}

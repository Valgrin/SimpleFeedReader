# SimpleFeedReader

## Test

In order to assess this test we will require you to create a Github/Bitbucket repository and commit your code to it throughout the duration of the test. This test will assess your 

knowledge of the iOS SDK, API interaction and Git usage. Please spend no more than 2 hours on this test. If you run out of time, leave a comment in AppDelegate.m suggestinghow much longer you felt you would need and roughly how you would implement the rest 

The task is to parse the list of new films on www.fandango.com and present them in an iOS application as an alphabetically sorted list. 

- The feed for the data you will be using can be found at this url http://www.fandango.com/rss/newmovies.rss.
- The items must be sorted alphabetically by the "title" tag found in the 'entry' element.
 
This information can be presented in any way you consider appropriate. 

## Bonus points

None of these are required but can be done if you feel you have time. You are free to add any extra functionality to further demonstrate your ability if you wish. 

- When sorting the list, ignore the stop words (words which offer no content such as 'the', 'a', 'of' etc.)
- Displaying the thumbnail image of the film in the UITableViewCell
- Instead of sorting alphabetically, sort the list by their Rotten Tomatoes scores
 
This data can be fetched from the url: "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=qrbt5gajqa75qutk6mftdjvk &q=[film title goes here]" (A new API Key can be created at http://developer.rottentomatoes.com) 

You can assume that if the Rotten Tomatoes API is passed the correct film title, the first result in the returned JSON is the correct film.

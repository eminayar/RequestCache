# RequestCache
## Description
  This is a toy project to understand the basic structure of **ruby on rails** and how the **back-end** side of an application works. I parsed 1000 videos from youtube( id,like count,dislike count etc. ) and made a simple database. I made pagination and when pages are requested i cached the data to a **JSON** file so that when the same request comes again the server doesn't ask for information from database and therefore responses are faster.
## What did i use
* Youtube data api
* Ruby on rails
## How to run
* To test youtube parser you need to download your own *client secret* file from google api services.
1. Go to web/
2. Run `rails server`
3. Run `rake db:migrate`
4. Open your web browser and type `localhost:3000`

# README

This is a simple API for some bond holdings using Rails 6.
It follows the JSON API standard.

Some sample holding data is already included in the repo.
In order to initialize the data, start a rails console and run:
`DataImporter.run`
and it will automatically import the data from data/holdings-list.csv into the
database.

Then you can start the rails server and use normal JSON API requests to interact
with the data. For example, you can run:
```
curl -i -H "Accept: application/vnd.api+json" "http://localhost:3000/holdings"
```
to get a list of all holdings in the database in JSON API format.

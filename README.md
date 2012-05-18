Anita
=====

![Anita Borg](http://i.imgur.com/XOY0N.jpg)

[Anita](http://en.wikipedia.org/wiki/Anita_Borg), Mendicant Universities IRC
Bot.

Usage
-----

```bash
git clone git://github.com/mendicant/anita.git
cd anita
rake start
```

When running `rake start` anita will install her dependencies, help you create
a default configuration and initialize the database. She will then start up
both her bot and web interfaces.

To access anita's logs via her web interface navigate to:
  
  `http://localhost:5000/:channel/:from..:to`
  
By default Anita will server you up a nice html view of your request. However
you can also provide an optional extension for alternate formats. Below is a
list of the extensions Anita currently knows.

- **.markdown** -- This produces markdown formatted output you can copy/paste
  (short version: .md)
- **.html** -- The default html view
- **.json** -- JSON formatted raw data (short version: .js)

If you know the name of a past, present (or future) activity you can do this:

  `http://localhost:5000/activities/:description`

This URI takes the same, optional, extensions.

Roadmap
-------

1. Get anita logging channels. (done)
2. Create a web service to retrieve logs. (done)

Contributing
------------

Fork the repo, make your changes (you can use #mendicant-bots as a testing
channel) and send a pull request. Please don't wait until you've completed
your work to send a pull request. The sooner you start a discussion, the
better.

require 'mysql2'
require 'sequel'
require 'sinatra'

DB = Sequel.connect({:adapter => 'mysql2', :user => 'root', :host => 'localhost', :database => 'nouns_verbed'})

get '/' do
  '<html>
  <body>
    <h1>HALLO</h1>
    <form method="post" action="/new_entry">
        <label for="noun_singular">Noun singular</label>
        <input type="text" class="input" name="noun_singular"/>

        <label for="noun_plural">Noun plural</label>
        <input type="text" class="input" name="noun_plural"/>

        <label for="verb_base">Verb base form</label>
        <input type="text" class="input" name="verb_base"/>

        <label for="verb_past">Verb past tense</label>
        <input type="text" class="input" name="verb_past"/>


        <input type="submit" value="Start Tracking">
  </body>
  </html>'
  # form!
end

post '/new_entry' do
  # look at request parameters and write to DB
  DB[:tracked_things].insert_ignore << {
    noun_singular:  params[:noun_singular],
    noun_plural:    params[:noun_plural],
    verb_base:      params[:verb_base],
    verb_past:      params[:verb_past],
  }
    redirect '/'
  # respond with something.
end

# verb_base = ARGV[0]
# verb_past = ARGV[1]
# noun_singular = ARGV[2]
# noun_plural = ARGV[3]

# DB["INSERT INTO tracked_things (verb_base, verb_past, noun_singular, noun_plural) VALUES(?, ?, ?, ?);",
# 	verb_base, verb_past, noun_singular, noun_plural].all

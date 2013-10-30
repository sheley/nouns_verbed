require 'mysql2'
require 'sequel'
require 'sinatra'

DB = Sequel.connect({:adapter => 'mysql2', :user => 'root', :host => 'localhost', :database => 'nouns_verbed'})

get '/tracked_things/new' do
  '<html>
  <body>
    <h1>HALLO</h1>
    <form method="post" action="/tracked_things/new">
        <label for="noun_singular">Noun singular</label>
        <input type="text" class="input" name="noun_singular"/>

        <label for="noun_plural">Noun plural</label>
        <input type="text" class="input" name="noun_plural"/>

        <label for="verb_base">Verb base form</label>
        <input type="text" class="input" name="verb_base"/>

        <label for="verb_past">Verb past tense</label>
        <input type="text" class="input" name="verb_past"/>


        <input type="submit" value="Start Tracking">
    </form>
  </body>
  </html>'
end

post '/tracked_things/new' do
  # look at request parameters and write to DB
  DB[:tracked_things].insert_ignore << {
    noun_singular:  params[:noun_singular],
    noun_plural:    params[:noun_plural],
    verb_base:      params[:verb_base],
    verb_past:      params[:verb_past],
  }
  # respond with something.
    redirect '/'
end

get '/tracking_data/new' do
  rows = DB[:tracked_things].all # run query, return list of rows
  form_field_list =
    rows.map do |row|
      a = 'I %s' % row[:verb_past]
      b = '<input type="text" class="input" name="count_%s"/>' % row[:id]
      c = '%s.' % row[:noun_plural]

      "%s %s %s<br>\n" % [ a, b, c ]
      end


 '<html>
  <body>
    <h1>HEYO</h1>
    <form method="post" action="/tracking_data/new">
        <label for="date">date YYYY-MM-DD</label>
        <input type="text" class="input" name="date"/>
        %s
        <input type="submit" value="Add Data">
    </form>
  </body>
  </html>' % form_field_list.join
end

def insert_tracking_data(tracked_id, date, count)
  DB[:tracking_data].on_duplicate_key_update << {
    date: date,
    count: count,
    tracked_id: tracked_id,
   }
end

def make_count_field_name(tracked_id)
  ("count_%s" % tracked_id).to_sym
end



post '/tracking_data/new' do

#look at params keys and filter them based on the prefix count.
#remove others. remove "count_" so only the id number is taken. 
# params = {:date => '2013-10-30', :count_1 => 1, :count_2 => 2, :count_3 => 3}

  tracked_ids =  params.keys.select do |key|
    key.to_s.start_with?("count_")
  end.
    map do |key|
    key[6..-1].to_i
  end

  tracked_ids.map do |tracked_id|
      insert_tracking_data(tracked_id, params[:date], params[make_count_field_name(tracked_id)])
  end


   "we're done here."
end


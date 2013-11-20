$LOAD_PATH <<  File.expand_path('.')
require 'mysql2'
require 'sequel'
require 'sinatra'
require 'templates'

DB = Sequel.connect({:adapter => 'mysql2', :user => 'root', :host => 'localhost', :database => 'nouns_verbed_mock_up'})

get '/tracked_things/new' do
  Templates.new_things_form
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

def fetch_tracked_things
  DB[:tracked_things].all # run query, return list of rows
end

def render_new_data_form(tracked_things)
  form_field_list = tracked_things.map do |row|
    Templates.tracked_thing_input_field(row)
  end
  Templates.new_data_form(form_field_list)
end

get '/tracking_data/new' do
  render_new_data_form(fetch_tracked_things)
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

def summed_counts_per_nouns_verbed
  DB["SELECT verb_past, noun_plural, SUM(`count`) 'count'
    FROM tracked_things t inner join tracking_data d
    ON t.id = d.tracked_id
    GROUP BY tracked_id"].all
end


get '/' do
  sentences = summed_counts_per_nouns_verbed.map do |row|
    Templates.make_total_sentence(row[:verb_past], row[:count], row[:noun_plural])
  end
  Templates.render_tracked_thing_total_list(sentences)
end

get '/graphs' do
  render_bar_graph(
    make_bars(totals_per_month_year_per_thing)
  )
end


def render_bar_graph(all_the_bars)
  '<html>
    <head>
      <link rel="stylesheet" href="/styles.css">
    </head>
    <body>
      <h1>Pretty Graphs</h1>
      %s
    </body>
  </html>' % all_the_bars
end

def totals_per_month_year_per_thing
  DB["SELECT SUM(count) AS total_per_month_year, EXTRACT(YEAR_MONTH FROM date) 'year_month', tracked_id
  FROM tracking_data GROUP BY tracked_id, EXTRACT(YEAR_MONTH FROM date)"].all
end

def make_bars(monthly_totals_rows)
  monthly_totals_rows.map do |row|
    # {:total_per_month_year=>23, :year_month=>201311, :tracked_id=>1}
    make_bar(row[:year_month], row[:total_per_month_year])
  end.join("\n")
end

def make_month(year_month)
  year_month.to_s
end

def make_count(total_per_month_year)
  '<span class="count">%s</span>' % total_per_month_year.to_s
end


def make_thing
  '<div class="thing">
  </div>'
end

def make_bar(year_month, total)
  '<div class="bar">
      %s
  </div>' % (make_month(year_month) + make_inner_bar(total) + make_count(total))
end

def make_inner_bar(length)
  make_thing * length
end

#fantasy code
# i need to create a number of "thing" divs equal to the total count per month_year.
# map over this: count total per month_year --> create thing divs, wrap in bar div by month_year


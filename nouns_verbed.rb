$LOAD_PATH <<  File.expand_path('.')
require 'mysql2'
require 'sequel'
require 'sinatra'
require 'templates'
require 'queries'

DB = Sequel.connect({:adapter => 'mysql2', :user => 'root', :host => 'localhost', :database => 'nouns_verbed_mock_up'})

def queries
  Queries.new(DB)
end

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

def render_new_data_form(tracked_things)
  form_field_list = tracked_things.map do |row|
    Templates.tracked_thing_input_field(row)
  end
  Templates.new_data_form(form_field_list)
end

get '/tracking_data/new' do
  render_new_data_form(queries.fetch_tracked_things)
end

def make_count_field_name(tracked_id)
  ("count_%s" % tracked_id).to_sym
end




  #look at params' keys and filter them based on the prefix count.
  #remove others. remove "count_" so only the id number is taken. 
  # params = {:date => '2013-10-30', :count_1 => 1, :count_2 => 2, :count_3 => 3}
def tracked_ids(tracking_data_params)
  tracking_data_params.keys.select do |key|
    key.to_s.start_with?("count_")
  end.
  map do |key|
    key[6..-1].to_i
  end
end


post '/tracking_data/new' do
  tracked_ids(params).map do |tracked_id|
    queries.insert_tracking_data(tracked_id, params[:date], params[make_count_field_name(tracked_id)])
  end
  redirect '/'
end




get '/' do
  sentences = queries.summed_counts_per_nouns_verbed.map do |row|
    Templates.make_total_sentence(row[:verb_past], row[:count], row[:noun_plural])
  end
  Templates.render_tracked_thing_total_list(sentences)
end

get '/graphs' do
  Templates.render_bar_graph(
    Templates.make_bars(queries.totals_per_month_year_per_thing)
  )
end


#fantasy code
# i need to create a number of "thing" divs equal to the total count per month_year.
# map over this: count total per month_year --> create thing divs, wrap in bar div by month_year


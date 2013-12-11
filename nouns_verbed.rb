$LOAD_PATH <<  File.expand_path('.')
require 'mysql2'
require 'sequel'
require 'sinatra'
require 'templates'
require 'queries'
require 'users'
require 'dotenv'

Dotenv.load

use Rack::Session::Cookie, :secret => ENV['SESSION_SECRET']


DB = Sequel.connect({:adapter => 'mysql2', :user => 'root', :host => 'localhost', :database => 'nouns_verbed'})

def queries
  Queries.new(DB)
end

def users
  Users.new(DB)
end

get '/tracked_things/new' do
  if session[:user_id]
    Templates.new_things_form
  else
    redirect '/error'
  end
end

post '/tracked_things/new' do
  if session[:user_id]
    # look at request parameters and write to DB
    queries.insert_tracked_thing(params[:noun_singular], params[:noun_plural], params[:verb_base], params[:verb_past])
    #response
    redirect '/tracking_data/new'
  else
    redirect '/error'
  end
end

def render_new_data_form(tracked_things)
  form_field_list = tracked_things.map do |row|
    Templates.tracked_thing_input_field(row)
  end
  Templates.new_data_form(form_field_list)
end

get '/tracking_data/new' do
  if session[:user_id]
    render_new_data_form(queries.fetch_tracked_things)
  else
    redirect '/error'
  end
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
  if session[:user_id]
    tracked_ids(params).map do |tracked_id|
      queries.insert_tracking_data(tracked_id, params[:date], params[make_count_field_name(tracked_id)])
    end
    redirect '/tracking_data/stats'
  else
    redirect '/error'
  end
end

get '/tracking_data/stats' do
  if session[:user_id]
    sentences = queries.summed_counts_per_nouns_verbed.map do |row|
      Templates.make_total_sentence(row[:verb_past], row[:count], row[:noun_plural])
    end
    Templates.render_tracked_thing_total_list(sentences)
  else
    redirect '/error'
  end
end

get '/tracking_data/graphs' do
  if session[:user_id]
    Templates.render_bar_graph(
      Templates.make_bars(queries.totals_per_month_year_per_thing)
    )
  else
    redirect '/error'
  end
end

get '/' do
# ####  new_user_form
  if session[:user_id]
    redirect '/tracking_data/new'
  else
    '<html>
    <body>
      <h1>start tracking the nouns you are verbing</h1>
      <form method="post" action="/new_user">

          <label for="username">username</label>
          <input type="text" class="input" name="username"/><br><br>

          <label for="password">password</label>
          <input type="password" class="input" name="password"/><br><br>

          <input type="submit" value="Sign me up!">
      </form>
      <a href="/login">I already have an account.</a>
    </body>
    </html>'
  end
end

post '/new_user' do
  users.insert_new_user(params[:username], params[:password])
  session[:user_id] = users.find_user(params[:username])[:id]
  redirect '/tracked_things/new'
end


get '/login' do
  '<html>
  <body>
    <h1>Please login</h1>
    <form method="post" action="/login">

        <label for="username">username</label>
        <input type="text" class="input" name="username"/><br><br>

        <label for="password">password</label>
        <input type="password" class="input" name="password"/><br><br>

        <input type="submit" value="Sign in">
    </form>
  </body>
  </html>'
end

post '/login' do
# #### something that checks the info
  if user = users.authenticate(params[:username], params[:password])
    session[:user_id] = user[:id]
    redirect '/tracking_data/new'
  else
    redirect '/login_fail'
  end
end

get '/login_fail' do
  '<html>
  <body>
    <h1>Oops. Combination not correct.</h1>
    <a href="/login">Try again</a><br>
    or<br>
    <a href="/">Sign up</a>
  </body>
  </html>'
end

get '/error' do
  '<html>
  <body>
    <h1>Oops. You need to log in for that.</h1>
    <a href="/login">Log in</a><br>
    or<br>
    <a href="/">Sign up</a>
  </body>
  </html>'
end

get '/logout' do
  session.clear
  '<html>
  <body>
    <h1>Byeeeeeeee</h1>
    <a href="/login">Log in</a><br>
    or<br>
    <a href="/">Sign up</a>
  </body>
  </html>'
end




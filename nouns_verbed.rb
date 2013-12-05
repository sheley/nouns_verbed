$LOAD_PATH <<  File.expand_path('.')
require 'mysql2'
require 'sequel'
require 'sinatra'
require 'templates'
require 'queries'
require 'users'

DB = Sequel.connect({:adapter => 'mysql2', :user => 'root', :host => 'localhost', :database => 'nouns_verbed'})

def queries
  Queries.new(DB)
end

def users
  Users.new(DB)
end

get '/tracked_things/new' do
  Templates.new_things_form
end

post '/tracked_things/new' do
  # look at request parameters and write to DB
  queries.insert_tracked_thing(params[:noun_singular], params[:noun_plural], params[:verb_base], params[:verb_past])
  #response
    redirect '/tracking_data/new'
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
  redirect '/tracking_data/stats'
end

get '/tracking_data/stats' do
  sentences = queries.summed_counts_per_nouns_verbed.map do |row|
    Templates.make_total_sentence(row[:verb_past], row[:count], row[:noun_plural])
  end
  Templates.render_tracked_thing_total_list(sentences)
end

get '/tracking_data/graphs' do
  Templates.render_bar_graph(
    Templates.make_bars(queries.totals_per_month_year_per_thing)
  )
end

get '/' do
# ####  new_user_form
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

post '/new_user' do
# look at request parameters and write to DB
  users.insert_new_user(params[:username], params[:password])
  # respond with something.
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
  if users.authenticate?(params[:username], params[:password]) == true
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

post '/login/fail' do
end

# {'a' => 'b'} # => 'a=b'
def key_valueize(hash)
end

def set_cookie(hash)
  response.headers['Set-Cookie'] = key_valueize(hash)
end

class SmartHeaders
  def initialize
    @hash = {}
  end

  def add(header_name, header_value)
    if header_name == 'Set-Cookie'
      # header_value is a hash!! because we can!!
      # because thi is arbitrary!!
      @hash[header_name] = to_cookie_syntax(header_value)
    else
      @hash[header_name] = header_value
    end
  end

  def to_http_syntax
    result = ''
    @hash.each do |header_name, header_value|
      result << "%s: %s\n" % [ header_name, header_value ]
    end
    result
  end

  def to_cookie_syntax(cookie_hash)
    result = ''
    cookie_hash.each do |name, value|
      result << "%s=%s\n" % [ name, value]
    end
    result
  end
end


get '/cookie' do
  headers = Headers.new
  headers.add('Set-Cookie', )
  response.headers['Set-Cookie'] = ''
  set_cookie({'a' => 'b'})
  'cookie'
end

post '/cookie' do
end






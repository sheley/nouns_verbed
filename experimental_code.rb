











#2x
# hash --> symbols --> string --> string

# hash1
# DB[:tracked_things].all
# => [{:id=>1, :noun_singular=>"page", :noun_plural=>"pages",
# 	:verb_base=>"write", :verb_past=>"wrote"}]

#



get '/' do
end

post '/' do
end






# I want a function that will render a stat_total_list (the current
#total numbers of each tracked thing)
def summed_counts_per_nouns_verbed
  DB["select verb_past, noun_plural, sum(`count`) 'count'
    from tracked_things t inner join tracking_data d
    on t.id = d.tracked_id
    group by tracked_id"].all
end

def make_total_sentence(verb, count_total, noun)
  '<p>So far I %s %s %s.</p>' [verb, count_total, noun]
end

def render_tracked_thing_total_list(sentences)
  '<html>
  <body>
    <h1>STATS</h1>
    %s
  </body>
  </html>' % sentences.join
end

get '/'
  sentences = summed_counts_per_nouns_verbed.map do |row|
    make_total_sentence(row[:verb_past], row[:count], row[:noun_plural])
  end
  render_tracked_thing_total_list(sentences)
end




# To do that, I need to get information from two different hashes:

# I need :verb_past and :noun_plural from the hash representing the
# rows from tracked_thing DB
#info I need from hash DB[:tracked_things].all

#info I need from hash DB[:tracking_data].all
# I also need the count columns corresponding by ID number totaled
# and then I can pair it with the correct :verb_past and :noun_plural
#haven't figure this out yet




# I will have to map the hash to make sure I retrieve this for each
#tracked thing







#do I need this?
  
# def fetch_tracking_data
#   DB[:tracking_data].all # run query, return list of rows
# end


class Queries
  def initialize(db)
    @db = db
  end

  def fetch_tracked_things
    @db[:tracked_things].all # run query, return list of rows
  end

  def summed_counts_per_nouns_verbed
    @db["SELECT verb_past, noun_plural, SUM(`count`) 'count'
      FROM tracked_things t inner join tracking_data d
      ON t.id = d.tracked_id
      GROUP BY tracked_id"].all
  end

  def totals_per_month_year_per_thing
    @db["SELECT SUM(count) AS total_per_month_year, EXTRACT(YEAR_MONTH FROM date) 'year_month', tracked_id
    FROM tracking_data GROUP BY tracked_id, EXTRACT(YEAR_MONTH FROM date)"].all
  end

  def insert_tracking_data(tracked_id, date, count)
    puts "AAAA " + @db.inspect
    @db[:tracking_data].on_duplicate_key_update << {
      date: date,
      count: count,
      tracked_id: tracked_id,
     }
  end
end

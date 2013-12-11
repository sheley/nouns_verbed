module Templates
  def self.new_things_form
  '<html>
    <body>
      <h1>What nouns would you like to verb?</h1>
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
      <a href="/logout">log out</a>
    </body>
    </html>'
    end

  def self.new_data_form(tracked_data_input_fields)
    '<html>
    <body>
      <h1>How many nouns did you verb?</h1>
      <form method="post" action="/tracking_data/new">
          <label for="date">date YYYY-MM-DD</label>
          <input type="text" class="input" name="date"/><br><br>
          %s
          <input type="submit" value="Add Data">
      </form>
      <a href="/logout">log out</a>
    </body>
    </html>' % tracked_data_input_fields.join
  end

  def self.tracked_thing_input_field(row)
    a = 'I %s' % row[:verb_past]
    b = '<input type="text" class="input" name="count_%s"/>' % row[:id]
    c = '%s.' % row[:noun_plural]

    "%s %s %s<br>\n" % [ a, b, c ]
  end

  def self.make_total_sentence(verb, count_total, noun)
    '<p>So far I %s %s %s.</p>' % [verb, count_total, noun]
  end

  def self.render_tracked_thing_total_list(sentences)
    '<html>
    <body>
      <h1>STATS</h1>
      %s
    </body>
    </html>' % sentences.join
  end

  def self.render_bar_graph(all_the_bars)
    '<html>
      <head>
        <link rel="stylesheet" href="/styles.css">
      </head>
      <body>
        <h1>Pretty Graphs</h1>
        %s
        <a href="/logout">log out</a>
      </body>
    </html>' % all_the_bars
  end

  def self.make_bars(monthly_totals_rows)
    monthly_totals_rows.map do |row|
      # {:total_per_month_year=>23, :year_month=>201311, :tracked_id=>1}
      make_bar(row[:year_month], row[:total_per_month_year])
    end.join("\n")
  end

  def self.make_month(year_month)
    year_month.to_s
  end

  def self.make_count(total_per_month_year)
    '<span class="count">%s</span>' % total_per_month_year.to_s
  end

  def self.make_thing
    '<div class="thing">
    </div>'
  end

  def self.make_bar(year_month, total)
    '<div class="bar">
        %s
    </div>' % (make_month(year_month) + make_inner_bar(total) + make_count(total))
  end

  def self.make_inner_bar(length)
    make_thing * length
  end
end

module Templates
  def self.new_data_form(tracked_data_input_fields)
    '<html>
    <body>
      <h1>HEYO</h1>
      <form method="post" action="/tracking_data/new">
          <label for="date">date YYYY-MM-DD</label>
          <input type="text" class="input" name="date"/><br><br>
          %s
          <input type="submit" value="Add Data">
      </form>
    </body>
    </html>' % tracked_data_input_fields.join
  end

  def self.tracked_thing_input_field(row)
    a = 'I %s' % row[:verb_past]
    b = '<input type="text" class="input" name="count_%s"/>' % row[:id]
    c = '%s.' % row[:noun_plural]

    "%s %s %s<br>\n" % [ a, b, c ]
  end
end

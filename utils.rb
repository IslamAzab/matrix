module Utils
  def clean data
    data.strip.gsub("\"","")
  end

  def format_time time_string
    # time_string.strftime('%Y-%m-%dT%H:%M:%S')
    time_string.gsub("Z","")
  end

  def parse_time time_string
    Time.parse(time_string).utc.strftime('%Y-%m-%dT%H:%M:%S')
  end

  def custom_csv file_path
    rows = []
    # CSV does not like spaces between the col-sep and the quote character.
    # More info: https://stackoverflow.com/a/19042554/2125520
    quote_chars = %w(" | ~ ^ & *)
    begin
      CSV.foreach(file_path, headers: :first_row, quote_char: quote_chars.shift) do |row|
        rows << row
      end
    rescue CSV::MalformedCSVError => e
      quote_chars.empty? ? raise : retry
      puts e
    end
    return rows
  end
end
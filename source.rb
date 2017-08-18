class Source
  def initialize(path)
    @path = path
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
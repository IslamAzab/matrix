class Sniffer < Source
  def parse
    sequences = read_sequences

    node_times = read_node_times

    routes = []
    custom_csv("#{@path}/routes.csv").each do |row|
      route_id  = clean(row[0])
      time      = clean(row[1])
      time_zone = clean(row[2])

      time       = Time.parse("#{time} #{time_zone}")
      start_time = format_time(time.iso8601)

      if sequences[route_id]
        sequences[route_id].each do |node_time_id|
          node_time = node_times[node_time_id]

          if node_time
            r = {}
            start_node               = node_time[:start_node]
            end_node                 = node_time[:end_node]
            duration_in_milliseconds = node_time[:duration_in_milliseconds]

            time          = (time + duration_in_milliseconds.to_f/1000)
            end_time      = format_time(time.iso8601)

            r[:start_node] = start_node
            r[:end_node]   = end_node

            r[:start_time] = start_time
            r[:end_time]   = end_time
            routes << r

            # the next hop in route should start from last time
            start_time = end_time
          else
            puts "node_time_id: #{node_time_id} is missing!"
          end
        end
      else
        puts "route_id: #{route_id} is missing!"
      end
    end

    puts routes
    puts "-"*50

    return routes
  end

  private
  def read_sequences
    sequences = {}
    custom_csv("#{@path}/sequences.csv").each do |row|
      route_id     = clean(row[0])
      node_time_id = clean(row[1])
      if sequences[route_id]
        sequences[route_id] << node_time_id
      else
        sequences[route_id] = [node_time_id]
      end
    end
    sequences
  end

  def read_node_times
    node_times = {}
    custom_csv("#{@path}/node_times.csv").each do |row|
      node_time_id             = clean(row[0])
      start_node               = clean(row[1])
      end_node                 = clean(row[2])
      duration_in_milliseconds = clean(row[3])

      node_times[node_time_id] = {
        start_node:               start_node,
        end_node:                 end_node,
        duration_in_milliseconds: duration_in_milliseconds
      }
    end
    node_times
  end
end
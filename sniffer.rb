class Sniffer < Source
  def parse
    sequences = {}
    custom_csv("#{@path}/sequences.csv").each do |row|
      route_id     = row[0].strip.gsub("\"","")
      node_time_id = row[1].strip.gsub("\"","")
      if sequences[route_id]
        sequences[route_id] << node_time_id
      else
        sequences[route_id] = [node_time_id]
      end
    end

    node_times = {}
    custom_csv("#{@path}/node_times.csv").each do |row|
      node_time_id             = row[0].strip.gsub("\"","")
      start_node               = row[1].strip.gsub("\"","")
      end_node                 = row[2].strip.gsub("\"","")
      duration_in_milliseconds = row[3].strip.gsub("\"","")

      node_times[node_time_id] = {
        start_node:               start_node,
        end_node:                 end_node,
        duration_in_milliseconds: duration_in_milliseconds
      }
    end

    routes = []
    custom_csv("#{@path}/routes.csv").each do |row|
      route_id  = row[0].strip.gsub("\"","")
      time      = row[1].strip.gsub("\"","")
      time_zone = row[2].strip.gsub("\"","")

      time       = Time.parse("#{time} #{time_zone}")
      start_time = time.iso8601.gsub("Z","")

      if sequences[route_id]
        sequences[route_id].each do |node_time_id|
          node_time = node_times[node_time_id]

          if node_time
            r = {}
            start_node               = node_time[:start_node]
            end_node                 = node_time[:end_node]
            duration_in_milliseconds = node_time[:duration_in_milliseconds]

            time          = (time + duration_in_milliseconds.to_f/1000)
            end_time      = time.iso8601.gsub("Z","")

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
    puts

    return routes
  end
end
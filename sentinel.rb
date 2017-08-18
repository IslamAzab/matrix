class Sentinel < Source
  def parse
    paths = {}

    custom_csv(@path).each do |row|
      sentinel = {}
      sentinel[:route_id] = row[0].strip.gsub("\"","")
      sentinel[:node]     = row[1].strip.gsub("\"","")
      sentinel[:index]    = row[2].strip.gsub("\"","")
      sentinel[:time]     = Time.parse(row[3].strip.gsub("\"","")).utc.strftime('%Y-%m-%dT%H:%M:%S')
      # sentinel[:time]     = Time.parse(row[3].strip.gsub("\"","")).utc.iso8601.gsub("Z","")

      if paths[sentinel[:route_id]]
        paths[sentinel[:route_id]] << sentinel
      else
        paths[sentinel[:route_id]] = [sentinel]
      end
    end

    routes = []

    paths.each do |route_id, nodes|
      puts "route_id: #{route_id}"
      nodes.sort_by! { |node| node[:index] }
      nodes.each_with_index do |node1, i|
        route = {}
        node2 = nodes[i+1]
        if node1 && node2
          puts "\t#{node1[:node]} --> #{node2[:node]}"
          puts "\t#{node1[:time]} --> #{node2[:time]}"


          route[:start_node] = node1[:node]
          route[:start_time] = node1[:time]

          route[:end_node]   = node2[:node]
          route[:end_time]   = node2[:time]

          routes << route
        else
          puts "\t#{node1[:node]}"
        end
      end
    end

    puts routes
    return routes
  end
end
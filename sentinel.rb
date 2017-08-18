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
      # sort nodes by index to maintain nodes order
      nodes.sort_by! { |node| node[:index] }
      # iterate over every two consecutive nodes
      nodes.each_cons(2) do |node1, node2|
        route = {}
        route[:start_node] = node1[:node]
        route[:start_time] = node1[:time]

        route[:end_node]   = node2[:node]
        route[:end_time]   = node2[:time]

        routes << route
      end
    end

    puts routes
    return routes
  end
end
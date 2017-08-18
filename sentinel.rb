class Sentinel < Source
  def parse
    routes = []

    get_paths.each do |route_id, nodes|
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
    puts "-"*50
    routes
  end

  private
  def get_paths
    paths = {}

    custom_csv(@path).each do |row|
      sentinel = {}
      sentinel[:route_id] = clean(row[0])
      sentinel[:node]     = clean(row[1])
      sentinel[:index]    = clean(row[2])
      sentinel[:time]     = parse_time((clean(row[3])))

      if paths[sentinel[:route_id]]
        paths[sentinel[:route_id]] << sentinel
      else
        paths[sentinel[:route_id]] = [sentinel]
      end
    end
    paths
  end

end
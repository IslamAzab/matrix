class Loophole < Source
  def parse
    node_pairs = get_node_pairs

    routes_hash = JSON.parse(routes_file)

    routes = []

    routes_hash["routes"].each do |route_entry|
      route = {}

      node_pair_id = route_entry["node_pair_id"]
      node = node_pairs[node_pair_id]
      if node
        route[:start_node] = node[:start_node]
        route[:end_node]   = node[:end_node]

        route[:start_time] = format_time(route_entry["start_time"])
        route[:end_time]   = format_time(route_entry["end_time"])
        routes << route
      else
        puts "node_pair_id: #{node_pair_id} doesn't exist!"
        puts
      end
    end

    puts routes
    puts "-"*50
    routes
  end

  private
  def routes_file
    @routes_file ||= File.read("#{@path}/routes.json")
  end

  def node_pairs_file
    @node_pairs_file ||= File.read("#{@path}/node_pairs.json")
  end

  def get_node_pairs
    node_pairs = {}

    node_pairs_hash = JSON.parse(node_pairs_file)

    node_pairs_hash["node_pairs"].each do |node_pair|
      node_pairs[node_pair["id"]] = {
        start_node: node_pair["start_node"],
        end_node:   node_pair["end_node"]
      }
    end
    node_pairs
  end

  def format_time time_string
    # time_string.strftime('%Y-%m-%dT%H:%M:%S')
    time_string.gsub("Z","")
  end
end
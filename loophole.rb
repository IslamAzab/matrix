class Loophole < Source
  def parse
    paths = {}

    node_pairs = {}

    node_pairs_file = File.read("#{@path}/node_pairs.json")
    node_pairs_hash = JSON.parse(node_pairs_file)

    # puts node_pairs_hash["node_pairs"]

    node_pairs_hash["node_pairs"].each do |node_pair|
      node_pairs[node_pair["id"]] = {
        start_node: node_pair["start_node"],
        end_node:   node_pair["end_node"]
      }
    end

    puts node_pairs
    puts "-"*50
    puts

    routes_file = File.read("#{@path}/routes.json")
    routes_hash = JSON.parse(routes_file)

    routes = []

    routes_hash["routes"].each do |route|
      r = {}
      puts route
      puts "-"*20
      puts

      node_pair_id = route["node_pair_id"]
      node = node_pairs[node_pair_id]
      if node
        r[:start_node] = node[:start_node]
        r[:end_node]   = node[:end_node]

        r[:start_time] = route["start_time"].gsub("Z","")
        r[:end_time]   = route["end_time"].gsub("Z","")
        # r[:start_time] = route["start_time"].strftime('%Y-%m-%dT%H:%M:%S')
        # r[:end_time]   = route["end_time"].strftime('%Y-%m-%dT%H:%M:%S')
        routes << r
      else
        puts "node_pair_id: #{node_pair_id} doesn't exist!"
        puts
      end
    end


    puts routes
    puts
    return routes
  end
end
require 'csv'
require 'time'
require 'net/http'
require 'json'
require 'yaml'

require "./source"
require "./sentinel"
require "./sniffer"
require "./loophole"

class Matrix

  def initialize
    config = YAML.load_file('config.yml')
    @passphrase = config["passphrase"]
    @uri        = config["uri"]
  end

  def run
    # parse sentinels
    sentinel  = Sentinel.new("data/sentinels/routes.csv")
    routes = sentinel.parse
    # send
    send_data routes, 'sentinels'

    # parse sniffers
    sniffer  = Sniffer.new("data/sniffers")
    routes = sniffer.parse
    # send
    send_data routes, 'sniffers'

    # parse loopholes
    loophole  = Loophole.new("data/loopholes")
    routes = loophole.parse
    # send
    send_data routes, 'loopholes'
  end

  def send_data routes, source
    response_codes = []
    uri = URI(@uri)
    routes.each do |route|
      data = {
        passphrase:  @passphrase,
        source:      source,
        start_node:  route[:start_node],
        end_node:    route[:end_node],
        start_time:  route[:start_time],
        end_time:    route[:end_time]
      }
      puts data.inspect
      puts "-"*50


      res = Net::HTTP.post_form(uri, data)
      puts res.body
      puts res.code
      response_codes << res.code if res

      puts
    end
    if response_codes.size == routes.size &&
       response_codes.uniq.size == 1 &&
       response_codes.uniq.first == "201"
      return true
    else
      return false
    end
  end
end

matrix = Matrix.new
matrix.run
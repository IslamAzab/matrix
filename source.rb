require './utils'

class Source
  include Utils
  def initialize(path)
    @path = path
  end
end
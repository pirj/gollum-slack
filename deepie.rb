class Deepie
  private

  def wrap value
    if value.is_a?(Hash)
      Mash.new(value)
    elsif value.is_a?(Array)
      Arrash.new(value)
    else
      value
    end
  end
end

# json = JSON.parse '{"a": 1, "b": {"c": [44,55]}}'
# mash = Mash.new json
# mash.b.c.last # => 55
class Mash < Deepie
  def initialize hash
    @hash = hash
  end

  def method_missing method_name, *_args
    wrap @hash[method_name.to_s]
  end
end

class Arrash < Deepie
  def initialize array
    @array = array
  end

  def [] index
    wrap @array[index]
  end

  def first
    wrap @array.first
  end

  def last
    wrap @array.last
  end
end

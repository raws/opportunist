class RankedPlayer < Player
  attr_reader :rank

  def initialize(name, rank)
    super name
    @rank = rank
  end

  def to_hash
    { name: name, rank: rank }
  end
end

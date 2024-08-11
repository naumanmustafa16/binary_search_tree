class TreeNode
  attr_accessor :data, :right, :left

  def initialize(data, right =nil, left = nil)
    @data = data
    @right = right
    @left = left
  end
end
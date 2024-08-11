require_relative "tree_node"
require_relative "queue"

class Tree
  attr_accessor :array, :root
  def initialize(array)
    @array = array
    @root = build_tree(array)
  end

  def build_tree(array)
    
    #base case
    if array.length == 0
      return nil
    else
      tree_array = array.sort.uniq
      mid =tree_array.length/2
      root = TreeNode.new(tree_array[mid])
    
      #left subtree
      root.left = build_tree(tree_array.slice(0,mid))

      #right subtree
      root.right = build_tree(tree_array.slice(mid+1, tree_array.length-1))   
    end
    return root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
  
  def insert(data, current = @root)
    #base case
    if data > current.data && current.right == nil
      current.right = TreeNode.new(data)
    elsif data < current.data && current.left == nil
      current.left = TreeNode.new(data)
    end 
    if data > current.data && current.right != nil
      insert(data,current.right)
    elsif data < current.data && current.left != nil
      insert(data,current.left)
    end
  end

  def delete(data, current = @root, predecessor = nil, 
    successor_right = current.right, successor_left = current.left)
    #Case-1 Deleting a leaf
    if current.data != data
      predecessor = current
      if current.data > data
       
        current = current.left
        successor_left = current.left
        successor_right = current.right
        delete(data,current, predecessor, successor_right, successor_left)
      elsif current.data < data
        current = current.right
        successor_left = current.left
        successor_right = current.right
        delete(data,current, predecessor, successor_right, successor_left)
      end
    else
      # case1- If we are at the leaf node
      if current.left == nil && current.right == nil
        if predecessor.data < data
            predecessor.right = nil
        else
            predecessor.left = nil
        end
      #case-2 the node to be deleted has one child
      elsif successor_right != nil && successor_left == nil
            predecessor.right = successor_right
      elsif successor_left != nil && successor_right == nil
            predecessor.left = successor_left
      #case 3 when the node to be deleted has 2 childern
      #The node to be deleted will be replaced by the 
      #smallest node of the list of the nodes which are greater than the node to be deleted
      elsif successor_right != nil && successor_left != nil
            
            replacement, replacement_predecessor = replacement(current,predecessor, successor_right, successor_left)
            replacement_predecessor.left = nil
            current.data = replacement.data
            
      end
  end

end

      def replacement(current, predecessor,successor_right,subtree)
        if successor_right.right == nil
          replacement_predecessor =current
          replacement = current.left
          while replacement.left != nil
            replacement_predecessor = replacement
            replacement = replacement.left
          end
          return replacement, replacement_predecessor
        else 
              new_successor_right = successor_right
            # if successor_right.right != nil
              while new_successor_right != nil
                new_predecssor_of_right = current.right
                new_successor_right = new_successor_right.right
              end
              replacement = new_predecssor_of_right.left
            # p successor_right
              replacement_predecessor = new_predecssor_of_right
            while replacement.left != nil
              replacement = replacement.left
              replacement_predecessor = replacement_predecessor.left
            end
            return replacement, replacement_predecessor
          end
        end
      
  def find(data, current=@root)
    if current.data == data
      return current
    else
      if current.data > data
        current = current.left
        find(data,current)
      elsif current.data < data
        current = current.right
        find(data,current)
      end
    end
  end

  def level_order(current = @root)
    queue = Queue.new
    arr = []
    if current == nil
      return nil
    else
      queue.enqueue(current)
    until queue.data.empty?
      current = queue.dequeue
      if current.left != nil
        queue.enqueue(current.left)
      end
      if current.right != nil
        queue.enqueue(current.right)
      end
      if block_given?
      yield(current)
      else 
        arr << current.data
      end
    end
    return arr
  end
  end

def preorder(current = @root,&block)
 
  if current == nil
  return nil
 else
  result = []
  if block_given?
    block.call(current)
    preorder(current.left, &block)
    preorder(current.right,  &block)
  else
    result << current.data
    result << preorder(current.left, &block)
    result << preorder(current.right,  &block)
    
  end
  result.compact.flatten unless block_given?

    
 end
end

def inorder(current = @root,&block)
 
  if current == nil
  return nil
 else
  result = []
  if block_given?

    preorder(current.left, &block)
    block.call(current)
    preorder(current.right,  &block)
  else

    result << preorder(current.left, &block)
    result << current.data
    result << preorder(current.right,  &block)
    
  end
  result.compact.flatten unless block_given?

    
 end
end
def postorder(current = @root,&block)
 
  if current == nil
  return nil
 else
  result = []
  if block_given?
    
    preorder(current.left, &block)
    preorder(current.right,  &block)
    block.call(current)
  else

    result << preorder(current.left, &block)
    result << preorder(current.right,  &block)
    result << current.data
  end
  result.compact.flatten unless block_given?

    
 end
end


def height(node = @root)
  return -1 if node.nil?

  left_height = height(node.left)
  right_height = height(node.right)

  [left_height, right_height].max + 1
end

def depth(node, current_node = @root)
  return 0 if current_node == node
  return -1 if current_node.nil?

  1 + depth(node, current_node.left) if node.value < current_node.value

  1 + depth(node, current_node.right)
end

def balanced?
  n = height(@root.left) - height(@root.right)
  n <= 1 && n >= 0
end

def rebalance
  build_tree(inorder)
end

end
tree1 = Tree.new((Array.new(15) { rand(1..100) }))
tree1.pretty_print
# tree1.preorder{|node| p node.data}
p tree1.height
p tree1.balanced?
p tree1.level_order
p tree1.preorder
p tree1.postorder
p tree1.inorder
tree1.insert(150)
tree1.insert(160)
tree1.insert(175)
tree1.insert(121)
tree1.insert(135)
tree1.pretty_print

p tree1.balanced?
# tree2 = Tree.new(tree1.inorder)
p tree2.rebalance
# tree1.pretty_print

p tree2.balanced?
tree1.pretty_print
tree2.pretty_print

# p tree1.level_order
# p tree1.preorder
# p tree1.postorder
# p tree1.inorder

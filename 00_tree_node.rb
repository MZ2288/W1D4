class PolyTreeNode

  attr_reader :value, :children, :parent

  def initialize(value, parent = nil, children = [])
    @value = value
    @parent = parent
    @children = children
  end

  def parent=(parent)
    if @parent
      @parent.children.delete(self)
    end
    @parent = parent
    if @parent
      @parent.children << self unless @children.include?(self)
    end
  end

  def add_child(child_node)
    child_node.parent=(self)
  end

  def remove_child(child)
    raise "Not a node!" unless child.is_a?(PolyTreeNode)
    raise "Not a child" unless children.include?(child)
    child.parent = nil
  end

  def dfs(target_value)
    return self if @value == target_value
    @children.each do |child|
      result = child.dfs(target_value)
      return result unless result.nil?
    end
    nil
  end

  def bfs(target_value)
    queue = []
    queue.unshift(self)
    until queue.empty?
      first_node = queue.shift
      return first_node if first_node.value == target_value
      first_node.children.each do |child|
        queue << child
      end
    end
  end
end

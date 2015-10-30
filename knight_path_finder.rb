require_relative '00_tree_node'
require 'byebug'

class KnightPathFinder
  attr_reader :starting_pos

  def initialize(pos)
    @starting_pos = pos
    @visited_positions = [pos]
    build_move_tree
  end

  def build_move_tree
    @root = PolyTreeNode.new(starting_pos)
    queue = [@root]
    until queue.empty?
      current_node = queue.shift
      new_moves = new_move_positions(current_node.value)
      new_moves.each do |move|
        node = PolyTreeNode.new(move)
        node.parent = current_node
      end
      queue += current_node.children
    end
    @root
  end

  def self.valid_moves(pos)
    possible_moves = [
      [1,2],[-1,2],[-2,-1],[1,-2],[2,1],[-2,1],[-1,-2],[-1,2]
    ]
    possible_moves.map! do |directions| [pos.first + directions.first,
      pos.last + directions.last]
    end

    possible_moves.select do |pos|
      pos.none? { |nums| nums < 0 || nums > 7 }
    end
  end


  def new_move_positions(pos)
    result = []
    KnightPathFinder::valid_moves(pos).each do |move|
      result << move unless @visited_positions.include?(move)
    end
    @visited_positions += result
    result
  end

  def find_path(end_pos)
    finish_node = @root.bfs(end_pos)
    trace_path_back(finish_node)
  end

  def trace_path_back(node)
    path = [node.value]
    until node.parent.nil?
      path << node.parent.value
      node = node.parent
    end
    path.reverse
  end
end

kpf = KnightPathFinder.new([0,0])
p kpf.find_path([7, 6]) # => [[0, 0], [1, 2], [2, 4], [3, 6], [5, 5], [7, 6]]
p kpf.find_path([6, 2]) # => [[0, 0], [1, 2], [2, 0], [4, 1], [6, 2]]
#

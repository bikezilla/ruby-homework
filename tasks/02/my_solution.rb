require 'forwardable'

class TodoList
  include Enumerable
  extend Forwardable

  attr_accessor :tasks

  def_delegators :@tasks, :[], :size, :each

  def self.parse(input_text)
    TodoList.new(input_text.split(/\n/).map do |line|
      status, description, priority, tags = line.split('|').map(&:strip)

      Task.new(status, description, priority, tags)
    end)
  end

  def initialize(tasks = [])
    self.tasks = tasks
  end

  def filter(criteria)
    TodoList.new tasks.select{ |task| criteria.call task }
  end

  def adjoin(other)
    TodoList.new(self.tasks | other.tasks)
  end

  def tasks_todo
    filter(Criteria.status(:todo)).size
  end

  def tasks_in_progress
    filter(Criteria.status(:current)).size
  end

  def tasks_completed
    filter(Criteria.status(:done)).size
  end

end

class Criteria
  extend Forwardable

  attr_accessor :c_lambda

  def_delegator :@c_lambda, :call

  class << self

    def status(status_value)
      Criteria.new -> (task) { task.status == status_value }
    end

    def priority(priority_value)
      Criteria.new -> (task) { task.priority == priority_value }
    end

    def tags(tag_values)
      Criteria.new -> (task) { (tag_values.map(&:to_sym) - task.tags).empty? }
    end

  end

  def initialize(c_lambda)
    self.c_lambda = c_lambda
  end

  def &(other)
    Criteria.new -> (task) { call(task) && other.call(task) }
  end

  def |(other)
    Criteria.new -> (task) { call(task) | other.call(task) }
  end

  def !
    Criteria.new -> (task) { !call(task) }
  end

end

class Task
  attr_accessor :status, :description, :priority, :tags

  def initialize(status, description, priority, tags)
    self.status = status.downcase.to_sym
    self.description = description
    self.priority = priority.downcase.to_sym
    self.tags = tags ? tags.split(',').map(&:strip).map(&:to_sym) : []
  end

end
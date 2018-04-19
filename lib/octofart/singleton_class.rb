require_relative 'workflow'

module Octofart
  module SingletonClass

    def workflow(&block)
      raise ArgumentError, 'Must provide a block' unless block_given?

      Class.new(Workflow) {
        _init
        class_eval(&block)
        _run
      }
    end

  end
end

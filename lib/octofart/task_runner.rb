module Octofart
  module TaskRunner
    extend self

    def run(params, tasks)
      result = tasks.reduce(params.dup) do |data, task|
        data.merge!(task.run(data))
      end

      result
    end

  end
end

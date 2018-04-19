require 'ostruct'

module Octofart
  class Config < OpenStruct

    def initialize(args = {})
      super defaults.merge(args)
    end

    def defaults
      @defaults ||= {
        github_token: nil,
        max_retries: 1,
        unique_head_branch_name: "find-and-replace-text"
      }
    end

  end
end

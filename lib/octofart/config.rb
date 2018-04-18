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
        candidate_base_branches: ["develop", "master"],
      }
    end

  end
end

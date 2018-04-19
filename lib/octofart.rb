require "octokit"
require "octofart/version"
require "octofart/config"
require "octofart/client"
require "octofart/singleton_class"
require "octofart/task_runner"

require "octofart/tasks/create_branch"
require "octofart/tasks/commits"
require "octofart/tasks/pull_request"
require "octofart/tasks/update_file"
require "octofart/tasks/data_mapping"
require "octofart/tasks/branch_mapping"

module Octofart
  extend SingleForwardable
  extend SingletonClass

  def_delegators :config, :unique_head_branch_name,
                          :github_token,
                          :max_retries

  def self.client
    @client ||= Client.new(
       max_retries: max_retries,
      access_token: github_token,
    )
  end

  def self.configure(&blk)
    yield(config)
  end

  def self.config
    @config ||= Config.new
  end

  private_class_method :config
end

require "octokit"
require "octofart/version"
require "octofart/config"
require "octofart/client"
require "octofart/parser"

module Octofart
  extend SingleForwardable

  def_delegators :config, :base_branch, :github_token, :max_retries

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

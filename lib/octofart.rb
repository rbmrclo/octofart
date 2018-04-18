require "octofart/version"
require "octofart/config"

module Octofart
  extend SingleForwardable

  def_delegators :config, :base_branch, :github_token

  def self.configure(&blk)
    yield(config)
  end

  def self.config
    @config ||= Config.new
  end

  private_class_method :config
end

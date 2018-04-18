module Octofart
  class Client

    DEFAULT_ARGS = {
      connection_options: {
        request: {
          open_timeout: 2,
          timeout: 5,
        }
      }
    }.freeze

    RETRYABLE_ERRORS = [
      Faraday::ConnectionFailed,
      Faraday::TimeoutError,
      Octokit::InternalServerError,
      Octokit::BadGateway
    ].freeze

    def initialize(max_retries: 1, **args)
      octokit_args = DEFAULT_ARGS.merge(args)

      @max_retries = max_retries || 1
      @client = Octokit::Client.new(**octokit_args)
    end

    def method_missing(method_name, *args, &block)
      retry_connection_failures do
        if @client.respond_to?(method_name)
          mutatable_args = args.map(&:dup)
          @client.public_send(method_name, *mutatable_args, &block)
        else
          super
        end
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @client.respond_to?(method_name) || super
    end

    private

    def retry_connection_failures
      retry_attempt = 0

      begin
        yield
      rescue *RETRYABLE_ERRORS
        retry_attempt += 1
        retry_attempt <= @max_retries ? retry : raise
      end
    end

  end
end

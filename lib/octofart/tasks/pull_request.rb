module Octofart
  module Tasks
    class PullRequest

      def run(params)
        params[:repositories].each_pair do |repo_name, metadata|
          Octofart.client.update_ref(repo_name, metadata[:head_branch][:name], metadata[:head_branch][:sha])

          pull_request_opts = [
            repo_name,
            metadata[:base_branch][:name],
            metadata[:head_branch][:ref],
            params[:pull_request][:title],
            params[:pull_request][:body]
          ]

          Octofart.client.create_pull_request(*pull_request_opts)
        end

        params
      end

    end
  end
end

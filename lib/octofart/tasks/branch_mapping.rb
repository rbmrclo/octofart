module Octofart
  module Tasks
    class BranchMapping

      def run(params)
        puts "Determining base branch of #{params[:repositories].size} repositories..."

        params[:repositories].each_pair do |repo_name, metadata|
          next if metadata[:base_branch][:name]
          puts "Getting base branch of #{repo_name}..."

          base_branch_name       ||= Octofart.client.repo(repo_name).default_branch
          base_branch_latest_sha ||= Octofart.client.branch(repo_name, base_branch_name).commit.sha

          metadata[:base_branch][:name] = base_branch_name
          metadata[:base_branch][:sha]  = base_branch_latest_sha

          puts "Detected `#{base_branch_name}` as default branch of #{repo_name} (HEAD at #{base_branch_latest_sha})"
        end

        params
      end

    end
  end
end

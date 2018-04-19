module Octofart
  module Tasks
    class CreateBranch

      def run(params)
        params[:repositories].each_pair do |repo_name, metadata|
          head_branch_name ||= params[:pull_request][:branch_name]
          head_branch_name ||= Octofart.unique_head_branch_name
          metadata[:head_branch][:name] ||= "heads/#{head_branch_name}"

          head_branch =
            begin
              Octofart.client.ref(repo_name, metadata[:head_branch][:name])
            rescue
              puts "Ref not found, so we'll create one."
              Octofart.client.create_ref(repo_name, metadata[:head_branch][:name], metadata[:base_branch][:sha])
            end

          metadata[:head_branch][:sha] = head_branch.object.sha
          metadata[:head_branch][:ref] = head_branch.ref
        end

        params
      end

    end
  end
end

module Octofart
  module Tasks
    class UpdateFile

      def run(params)
        params[:repositories].each_pair do |repo_name, metadata|
          metadata[:tasks].each do |task|
            file_info   = Octofart.client.contents(repo_name, { path: task[:path], branch: metadata[:base_branch][:name]})
            old_content = Base64.decode64(file_info.content)
            new_content = old_content.gsub(task[:find], task[:replace])

            task[:blob_sha] = Octofart.client.create_blob(repo_name, Base64.encode64(new_content), "base64")
          end
        end

        params
      end
    end
  end
end

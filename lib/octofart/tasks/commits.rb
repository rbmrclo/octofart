module Octofart
  module Tasks
    class Commits

      def run(params)
        params[:repositories].each_pair do |repo_name, metadata|
          metadata[:tasks].each do |task|
            tree_sha = new_tree_sha(repo_name, task[:path], task[:blob_sha], metadata[:head_branch][:sha])

            commit_args = [
              repo_name,
              task[:message],
              tree_sha,
              metadata[:head_branch][:sha]
            ]

            commit = Octofart.client.create_commit(*commit_args)
            metadata[:head_branch][:sha] = commit.sha # update the commit to latest
          end
        end

        params
      end

      private

      def head_tree_sha(repo_name, commit_sha)
        Octofart.client.commit(repo_name, commit_sha).commit.tree.sha
      end

      def new_tree_sha(repo_name, file_path, blob_sha, latest_commit_sha)
        opts = {
          path: file_path,
          mode: "100644",
          type: "blob",
           sha: blob_sha,
        }

        base_tree_opts = {
          base_tree: head_tree_sha(repo_name, latest_commit_sha)
        }

        Octofart.client.create_tree(repo_name, [opts], base_tree_opts).sha
      end

    end
  end
end

module Octofart
  class Workflow
    class << self

      private :new

      private

      def _init
        @tasks        = []
        @repositories = {}
        @pull_request = {}
        @organization = nil

        nil
      end

      def task_id
        @tasks.size + 1
      end

      def task(find:, replace:, message:)
        @tasks << { id: task_id, find: find, replace: replace, message: message }
      end

      def organization(org)
        @organization = org
      end

      def pull_request(title:, body:, branch_name: nil)
        @pull_request[:title] = title
        @pull_request[:body] = body
        @pull_request[:branch_name] = branch_name if branch_name
        @pull_request
      end

      def metadata
        @metadata ||= {
                 tasks: @tasks,
          organization: @organization,
          repositories: @repositories,
          pull_request: @pull_request
        }
      end

      def _run
        Octofart::TaskRunner.run metadata, [
          Octofart::Tasks::DataMapping.new,
          Octofart::Tasks::BranchMapping.new,
          Octofart::Tasks::CreateBranch.new,
          Octofart::Tasks::UpdateFile.new,
          Octofart::Tasks::Commits.new,
          Octofart::Tasks::PullRequest.new
        ]
      end
    end
  end
end

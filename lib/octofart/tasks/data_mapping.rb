module Octofart
  module Tasks
    class DataMapping

      def run(params)
        params[:tasks].each do |task|
          items = search(text: task[:find], org: params[:organization])
          items.each do |item|
            repo_name = item.repository.full_name

            init_repo_data(repo_name, params[:repositories])

            task_attrs = {
                   path: item.path,
                task_id: task[:id],
              repo_name: repo_name,
            }

            task_args = [
              params[:repositories],
              params[:tasks],
              task_attrs
            ]

            register_task(*task_args)
          end
        end

        clear(params)
        params
      end

      def init_repo_data(repo_name, repositories)
        puts "Initializing metadata for #{repo_name}..."

        repositories[repo_name] ||= {}
        repositories[repo_name][:tasks] ||= []
        repositories[repo_name][:base_branch] ||= {}
        repositories[repo_name][:head_branch] ||= {}

        puts repositories[repo_name]
      end

      def register_task(repositories, tasks, options = {})
        puts "Registering task for #{options[:repo_name]}..."

        task = tasks.find { |t| t[:id] == options[:task_id] }
        repositories[options[:repo_name]][:tasks] << task.merge!(path: options[:path])

        puts task
      end

      def search(text:, org:)
        Octofart.client.search_code(%Q{#{text} in:file org:#{org}})[:items]
      end

      def clear(params)
        params.delete(:items)
        params.delete(:tasks)
      end

    end
  end
end

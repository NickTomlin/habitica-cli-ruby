require "habitica_cli/task"

module HabiticaCli
  class Daily < Thor
    include HabiticaCli::Task

    desc "list", "list dailies"
    def list
      list_task_type("daily")
    end

    private

    def display(response)
      response.body.select do |task|
        task["type"] == "daily"
      end.each do |item|
        puts "- #{item["text"]}\n"
      end
    end
  end
end

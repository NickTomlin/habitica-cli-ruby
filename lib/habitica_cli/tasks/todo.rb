require "habitica_cli/task"

module HabiticaCli
  class Todo < Thor
    include HabiticaCli::Task

    desc "list", "list todos"
    def list
      list_task_type("todo")
    end

    private

    def display(response)
      response.body.select do |task|
        task["type"] == "todo" && task["completed"] != true
      end.each do |item|
        puts "- #{item["text"]}\n"
      end
    end
  end
end

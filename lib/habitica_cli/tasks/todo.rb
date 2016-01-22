require 'habitica_cli/task'

module HabiticaCli
  # nodoc
  class Todo < Thor
    include HabiticaCli::Task

    desc 'list', 'list todos'
    def list
      list_task_type('todo')
    end

    desc 'add <text>', 'add a new todo'
    def add(text)
      response = api.post(
        'user/tasks',
        type:  'todo',
        text: text
      )

      if response.success?
        puts "Added #{response.body['text']}"
      else
        puts "Error adding #{text}: #{response.body}"
      end
    end

    desc 'complete <id>', 'complete a todo'
    def complete(id)
      response = api.put(
        "user/tasks/#{id}",
        completed: true
      )

      if response.success?
        puts "Completed #{response.body['text']}"
      else
        puts "Error #{response.body}"
      end
    end

    private

    def display(response)
      tasks = response.body.select do |task|
        task['type'] == 'todo' && task['completed'] != true
      end

      tasks.each do |item|
        puts "- #{item['text']} #{item['id']}\n"
      end
    end
  end
end

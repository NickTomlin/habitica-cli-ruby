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
      api.post(
        'user/tasks',
        type:  'todo',
        text: text
      )
    end

    desc 'complete <id>', 'complete a todo'
    def complete(id)
      api.post(
        'user/tasks',
        id:        id,
        compelted: true
      )
    end

    private

    def display(response)
      tasks = response.body.select do |task|
        task['type'] == 'todo' && task['completed'] != true
      end

      tasks.each do |item|
        puts "- #{item['text']}\n"
      end
    end
  end
end

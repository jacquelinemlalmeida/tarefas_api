namespace :tasks do
  desc 'Atualiza status de tarefas com due_date vencida para "em_atraso"'
  task update_overdue: :environment do
    overdue_tasks = Task.where("due_date < ?", Date.today)
                        .where.not(status: ['concluida', 'cancelada', 'em_atraso'])

    count = overdue_tasks.update_all(status: 'em_atraso', updated_at: Time.current)

    puts "#{count} tarefa(s) marcadas como em_atraso."
  end
end

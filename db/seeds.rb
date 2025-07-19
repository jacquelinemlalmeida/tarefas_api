require 'faker'

STATUSES = %w[em_andamento em_atraso concluida cancelada]

puts "Limpando tarefas..."
Task.destroy_all

puts "Gerando tarefas..."

100.times do
  status = STATUSES.sample
  created_at = Faker::Date.backward(days: 30)
  due_date = [nil, Faker::Date.between(from: created_at, to: Date.today + 10)].sample

  # Se a tarefa estiver concluída ou cancelada, nunca atrasada
  status = 'em_andamento' if due_date.present? && due_date < Date.today && %w[concluida cancelada].include?(status)

  Task.create!(
    title: Faker::Lorem.sentence(word_count: rand(2..5)),
    description: Faker::Lorem.paragraph(sentence_count: 2),
    status: status,
    due_date: due_date,
    created_at: created_at
  )
end

puts "Tarefas criadas com sucesso!"

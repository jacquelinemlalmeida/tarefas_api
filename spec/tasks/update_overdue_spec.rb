require 'rails_helper'
require 'rake'

RSpec.describe 'tasks:update_overdue', type: :task do
  before :all do
    Rake.application.rake_require('tasks/tasks')
    Rake::Task.define_task(:environment)
  end

  let(:task) { Rake::Task['tasks:update_overdue'] }

  before(:each) do
    Task.delete_all
    task.reenable
  end

  it 'marca como em_atraso as tarefas vencidas e não concluídas/canceladas' do
    overdue = Task.create!(title: 'Vencida', due_date: Date.yesterday, status: 'em_andamento')
    concluida = Task.create!(title: 'Feita', due_date: Date.yesterday, status: 'concluida')
    cancelada = Task.create!(title: 'Cancelada', due_date: Date.yesterday, status: 'cancelada')
    futura = Task.create!(title: 'Ainda pode fazer', due_date: Date.tomorrow, status: 'em_andamento')

    task.invoke

    expect(overdue.reload.status).to eq('em_atraso')
    expect(concluida.reload.status).to eq('concluida')
    expect(cancelada.reload.status).to eq('cancelada')
    expect(futura.reload.status).to eq('em_andamento')
  end
end

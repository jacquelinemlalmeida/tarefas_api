require 'swagger_helper'

RSpec.describe 'Tasks API', type: :request do
  path '/tasks' do
    get('list tasks') do
      tags 'Tasks'
      produces 'application/json'
      parameter name: :status, in: :query, type: :string, description: 'Filtrar por status (em_andamento, em_atraso, concluida, cancelada)'
      parameter name: :title, in: :query, type: :string, description: 'Filtrar por título'
      parameter name: :description, in: :query, type: :string, description: 'Filtrar por descrição'
      parameter name: :created_at, in: :query, type: :string, format: :date, description: 'Filtrar por data de criação (YYYY-MM-DD)'
      parameter name: :due_date, in: :query, type: :string, format: :date, description: 'Filtrar por data de entrega (YYYY-MM-DD)'

      response(200, 'successful') do
        let(:status) { nil }
        let(:title) { nil }
        let(:description) { nil }
        let(:created_at) { nil }
        let(:due_date) { nil }

        before do
          Task.create!(
            title: 'Teste',
            description: 'Testando',
            status: 'em_andamento',
            due_date: Date.tomorrow
          )
        end

        run_test!
      end
    end

    post('create task') do
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          status: { type: :string },
          due_date: { type: :string, format: :date }
        },
        required: ['title']
      }

      response(201, 'created') do
        let(:task) { { title: 'Nova tarefa', description: 'Desc', status: 'em_andamento' } }
        run_test!
      end
    end
  end

  path '/tasks/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Task ID'

    get('show task') do
      tags 'Tasks'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { Task.create!(title: "Teste", status: "em_andamento").id }
        run_test!
      end
    end

    put('update task') do
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          status: { type: :string },
          due_date: { type: :string, format: :date }
        }
      }

      response(200, 'updated') do
        let(:id) { Task.create!(title: "Atualizar", status: "em_andamento").id }
        let(:task) { { title: 'Atualizado via Swagger' } }
        run_test!
      end
    end

    delete('cancel task') do
      tags 'Tasks'
      produces 'application/json'

      response(200, 'cancelled') do
        let(:id) { Task.create!(title: "Para cancelar", status: "em_andamento").id }
        run_test!
      end
    end
  end
end

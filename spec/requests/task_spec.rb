require 'rails_helper'

RSpec.describe "Tasks API", type: :request do
  let!(:tasks) { create_list(:task, 10) }
  let(:task_id) { tasks.first.id }

  describe "GET /tasks" do
    it "returns all tasks" do
      get "/tasks"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).size).to eq(10)
    end
  end

  describe "GET /tasks/:id" do
    it "returns the task" do
      get "/tasks/#{task_id}"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["id"]).to eq(task_id)
    end
  end

  describe "POST /tasks" do
    it "creates a task" do
      valid_params = { task: { title: "Nova tarefa", description: "Teste", status: "em_andamento" } }
      post "/tasks", params: valid_params
      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)["title"]).to eq("Nova tarefa")
    end
  end

  describe "PUT /tasks/:id" do
    it "updates the task" do
      put "/tasks/#{task_id}", params: { task: { title: "Atualizado" } }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["title"]).to eq("Atualizado")
    end
  end

  describe "DELETE /tasks/:id" do
    it "marks the task as cancelled" do
      delete "/tasks/#{task_id}"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["status"]).to eq("cancelada")
    end
  end
end

set :environment, 'development'

set :output, 'log/cron.log'

every 1.day, at: '1:00 am' do
  rake "tasks:update_overdue"
end

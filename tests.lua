
local utils_test = torch.TestSuite()
local tester = torch.Tester()

utils = require './utils'

function utils_test.load_data()

  train_data, train_label, validation_data, validation_label = utils.load_data()

  tester:eq(train_data:size(), torch.LongStorage{50000, 28, 28});
  tester:eq(train_label:size(), torch.LongStorage{50000});
  tester:eq(validation_data:size(), torch.LongStorage{10000, 28, 28});
  tester:eq(validation_label:size(), torch.LongStorage{10000});

  tester:eq(train_data:mean(), 0, 0.01)
  tester:eq(train_data:std(), 1, 0.01)
  tester:eq(validation_data:mean(), 0, 0.01)
  tester:eq(validation_data:std(), 1, 0.01)


  max, _ = torch.max(train_label)
  min, _ = torch.min(train_label)
  tester:eq(max, 10)
  tester:eq(min, 1)
  
end

function utils_test.get_batch()

  data = torch.rand(1000,28,28)
  batch_data = utils.get_batch(data, 1, 100)

  tester:eq(batch_data:size(), torch.LongStorage{100, 28, 28})
  tester:eq(data[1], batch_data[1])
  tester:eq(data[100], batch_data[100])

  batch_data = utils.get_batch(data, 2, 100)
  tester:eq(batch_data:size(), torch.LongStorage{100, 28, 28})
  tester:eq(data[101], batch_data[1])
  tester:eq(data[200], batch_data[100])

end

tester:add(utils_test)
tester:run()

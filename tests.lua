
local utils_test = torch.TestSuite()
local datasets_test = torch.TestSuite()
local tester = torch.Tester()

utils = require './utils'
datasets = require './datasets'

function datasets_test.mnist_normalized()

  train_data, train_label, validation_data, validation_label = datasets.mnist()

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

function datasets_test.mnist_unnormalized()

  train_data, train_label, validation_data, validation_label = datasets.mnist(false)

  tester:eq(train_data:size(), torch.LongStorage{50000, 28, 28});
  tester:eq(train_label:size(), torch.LongStorage{50000});
  tester:eq(validation_data:size(), torch.LongStorage{10000, 28, 28});
  tester:eq(validation_label:size(), torch.LongStorage{10000});

  max, _ = torch.max(train_data)
  min, _ = torch.min(train_data)
  tester:eq(max, 255)
  tester:eq(min, 0)
  
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

tester:add(datasets_test)
tester:add(utils_test)
tester:run()

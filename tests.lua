
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

tester:add(utils_test)
tester:run()

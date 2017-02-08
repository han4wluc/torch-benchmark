
mnist = require 'mnist'

utils = {}

local tester = torch.Tester()

function utils.load_data()

  fullset = mnist.traindataset()

  data = fullset.data:double()
  label = fullset.label

  for i=1,label:size()[1] do
    if label[i] == 0 then
      label[i] = 10
    end
  end

  mean = data:mean()
  std = data:std()
  data:add(-mean)
  data:div(std)

  train_data = data[{{1,50000}}]
  train_label = label[{{1,50000}}]

  validation_data = data[{{50001,60000}}]
  validation_label = label[{{50001,60000}}]

  return train_data, train_label, validation_data, validation_label

end

function calc_validation_loss(model, criterion, data, label)
  local output = model:forward(data)
  local loss = criterion:forward(output, label)
  return loss
end

function utils.feval(x_new)
  if x ~= x_new then
      x:copy(x_new)
  end
  
  dl_params:zero()
  
  local outputs = model:forward(batch_data)
  local loss = criterion:forward(outputs, batch_label)
  local dloss_doutputs = criterion:backward(outputs, batch_label)
  model:backward(batch_data, dloss_doutputs)
  
  return loss, dl_params
end

return utils

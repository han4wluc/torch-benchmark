
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

function utils.get_batch(data, index, batch_size)
  batch_start = ((index-1)*batch_size)+1
  batch_end = index * batch_size
  return data[{{batch_start,batch_end}}]
end

function utils.calc_accuracy(model, data, label)
    local results = model:forward(data)
    _, indices = torch.max(results, 2)
    indices = indices:view(indices:nElement())
    indices = indices:type('torch.IntTensor')
    label = label:type('torch.IntTensor')
    
    r = torch.eq(indices, label)

    correct = r:sum()
    total = r:nElement()
    
    accuracy = correct / total
    
    return accuracy    
end

return utils

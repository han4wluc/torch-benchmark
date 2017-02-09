
require 'nn'

models = {}

-- single hidden layer with ReLU
-- ReLU before Linear
function models.mlp_1()
  model = nn.Sequential()
  model:add(nn.Reshape(1,28,28))
  model:add(nn.ReLU(false))
  model:add(nn.View(1*28*28))
  model:add(nn.Linear(1*28*28,10))
  model:add(nn.LogSoftMax())
  return model
end

-- single hidden layer without ReLU
function models.mlp_2()
  model = nn.Sequential()
  model:add(nn.Reshape(1,28,28))
  model:add(nn.View(1*28*28))
  model:add(nn.Linear(1*28*28,10))
  model:add(nn.LogSoftMax())
  return model
end

-- multi hidden layer
function models.mlp_3()
  model = nn.Sequential()
  model:add(nn.Reshape(1,28,28))
  model:add(nn.ReLU(false))
  model:add(nn.View(1*28*28))
  model:add(nn.Linear(1*28*28,100))
  model:add(nn.ReLU(true))
  -- model:add(nn.Linear(100,100))
  -- model:add(nn.ReLU(true))
  model:add(nn.Linear(100,10))
  model:add(nn.LogSoftMax())
  return model
end

return models


require 'nn'

models = {}

mlp = nn.Sequential()
mlp:add(nn.Reshape(1,28,28))
mlp:add(nn.ReLU(true))
mlp:add(nn.View(1*28*28))
mlp:add(nn.Linear(1*28*28,10))
mlp:add(nn.LogSoftMax())

function models.mlp()
  model = nn.Sequential()
  model:add(nn.Reshape(1,28,28))
  model:add(nn.ReLU(true))
  model:add(nn.View(1*28*28))
  model:add(nn.Linear(1*28*28,10))
  model:add(nn.LogSoftMax())
  return model
end

return models

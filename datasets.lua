
mnist = require 'mnist'

datasets = {}

function datasets.mnist(normalize)
  local normalize = normalize == nil and true or normalize

  fullset = mnist.traindataset()

  data = fullset.data:double()
  label = fullset.label

  for i=1,label:size()[1] do
    if label[i] == 0 then
      label[i] = 10
    end
  end

  if normalize == true then
    mean = data:mean()
    std = data:std()
    data:add(-mean)
    data:div(std)
  end

  train_data = data[{{1,50000}}]
  train_label = label[{{1,50000}}]

  validation_data = data[{{50001,60000}}]
  validation_label = label[{{50001,60000}}]

  return train_data, train_label, validation_data, validation_label

end

return datasets

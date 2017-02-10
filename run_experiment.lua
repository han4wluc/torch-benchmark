
require 'nn'
require 'optim'
require 'image'
require 'pl'

utils = require './utils'
models = require'./models'
datasets = require './datasets'
Logger = require './logger'


function merge_tables(tables)
  tbl = {}
  for i=1,#tables do
    tbl = tablex.merge(tbl, tables[i], true)
  end
  return tbl
end


function load_structure(info)

    model_name = info.model
    data_size = info.data_size
    dataset_name = info.dataset
    criterion_name = info.criterion
    optim_name = info.optim

    train_data, train_label, validation_data, validation_label =  datasets[dataset_name]()

    if data_size ~= 0 then
        train_data = train_data[{{1,data_size}}]
        train_label = train_label[{{1,data_size}}]
    end

    model = models[model_name]()
    criterion = nn[criterion_name]()
    optimization = optim[optim_name]
    dataset = {train_data, train_label, validation_data, validation_label}

    return {
        model = model,
        criterion = criterion,
        optimization = optimization,
        dataset = dataset,
    }

end

function train(structure_json, variant)
    
    local structure = load_structure(structure_json)    
    local model = structure.model
    local criterion = structure.criterion
    local optimization = structure.optimization
    local dataset = structure.dataset
    local train_data, train_label, validation_data, validation_label =
        dataset[1], dataset[2], dataset[3], dataset[4]
    
    local sgd_params = variant.optim
    local train_params = variant.train

    torch.manualSeed(1)
    local batch_size = train_params.batch_size
    batch_size = batch_size == 0 and train_data:size()[1] or batch_size
    local n_of_batches = train_data:size()[1] / batch_size

    -- local epochs = train_params.epochs
    local epochs = 10
    
    logger = Logger(
        './results_2/' .. 'experiment_1', --path
        {'train_loss', 'validation_loss'}, -- log headers
        {
            structure = structure_json,
            variant = variant,
        }
    )

    x, dl_params = model:getParameters()
    local time_start = os.time()

    for epoch=1,epochs do

        local train_loss = 0
        
        for batch_number=1,n_of_batches do
            batch_data = utils.get_batch(train_data, batch_number, batch_size)
            batch_label = utils.get_batch(train_label, batch_number, batch_size)

            _, fs = optimization(utils.feval,x,sgd_params)
            train_loss = train_loss + fs[1]

        end
                
        train_loss = train_loss/n_of_batches
        
        local validation_loss = calc_validation_loss(model, criterion, validation_data, validation_label)

        logger:append_log({train_loss, validation_loss})
        
        local train_accuracy = utils.calc_accuracy(model, train_data, train_label)
        local validation_accuracy = utils.calc_accuracy(model, validation_data, validation_label)
        local total_train_time = os.time() - time_start
        
        local log_stuff = {
            train_accuracy = train_accuracy,
            validation_accuracy = validation_accuracy,
            total_train_time = total_train_time,
            variant = variant.no
        }

        logger:write_results(
          merge_tables({structure_json, log_stuff, variant.optim, variant.train})
        )
        
        print('train_accuracy', train_accuracy)
        print('validation_accuracy', validation_accuracy)

    end
end


structures_json = json.load('./experiments/experiment_1/structures.json')
variants_json = json.load('./experiments/experiment_1/variants.json')

train(structures_json[1], variants_json[1])



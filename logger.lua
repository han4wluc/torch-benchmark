
local pretty = require 'pl.pretty'

function round(x, decimals)
    assert(decimals > 0, 'decimals should be > 0')
    local mult = torch.pow(10, decimals-1)
    return torch.floor(x * mult) / mult
end

function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then
        io.close(f)
        return true
    else
        return false
    end
end

do
  local Logger = torch.class('Logger')
end

function Logger:__init(logs_dir, info)
  self.logs_dir = logs_dir
  self.info = info
  -- self.logs = 'epoch\tduration\ttrain_loss\tvalidation_loss\tlearning_rate'

  -- if not file_exists then
  os.execute('mkdir -p ' .. logs_dir)
  -- end

end

-- function Logger:append(epoch, duration, train_loss, validation_loss, learning_rate)
--   self.logs = self.logs .. '\n' .. epoch .. '\t' .. 
--     round(duration, 8) .. '\t' .. 
--     round(train_loss, 8) .. '\t' .. 
--     round(validation_loss, 8) .. '\t' .. 
--     learning_rate
-- end

function Logger:write()
  -- local logs_filepath = self.logs_dir .. '/losses.txt'
  local info_filepath = self.logs_dir .. '/info.txt'
  -- local file = io.open(logs_filepath, 'w')
  --     file:write(self.logs)
  --     file:close()
  local file = io.open(info_filepath, 'w')
      file:write(pretty.write(self.info))
      file:close()

end

function Logger:write_time(duration)
  local filepath = self.logs_dir .. '/duration.txt'
  local file = io.open(filepath, 'w')
      file:write(duration .. 'seconds')
      file:close()
end

return Logger


local pretty = require 'pl.pretty'
local json = require 'json'


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

function write_to_file(path, mode, content)
  local file = io.open(path, mode)
  file:write(content)
  file:close()
end

function Logger:__init(logs_dir, log_headers, info)

  os.execute('mkdir -p ' .. logs_dir)

  self.logfile_path = logs_dir .. '/losses.log'
  self.resultsFile_path = logs_dir .. '/results.json'
  local infofile_path = logs_dir .. '/info.json'

  json.save(infofile_path, info)
  write_to_file(self.logfile_path, 'w', table.concat(log_headers, '\t'))

end

-- function Logger:append(epoch, duration, train_loss, validation_loss, learning_rate)
--   self.logs = self.logs .. '\n' .. epoch .. '\t' .. 
--     round(duration, 8) .. '\t' .. 
--     round(train_loss, 8) .. '\t' .. 
--     round(validation_loss, 8) .. '\t' .. 
--     learning_rate
-- end

function Logger:write_results(results)
  json.save(self.resultsFile_path, results)
end

function Logger:append_log(columns)
  write_to_file(self.logfile_path, 'a', '\n' .. table.concat(columns, '\t'))
end

-- function Logger:write()
--   -- local logs_filepath = self.logs_dir .. '/losses.txt'
--   local info_filepath = self.logs_dir .. '/info.txt'
--   -- local file = io.open(logs_filepath, 'w')
--   --     file:write(self.logs)
--   --     file:close()
--   local file = io.open(info_filepath, 'w')
--       file:write(pretty.write(self.info))
--       file:close()

-- end

-- function Logger:write_result(results)

--   local filepath = self.logs_dir .. '/result.json'
--   json.save(filepath, results)

--   -- local file = io.open(filepath, 'w')
--   -- file:write(json.encode(results))
--   -- file:close()
-- end

return Logger

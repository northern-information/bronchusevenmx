filesystem = {}

function filesystem.init()
  filesystem.samples = {}
  filesystem.sample_path = "/home/we/dust/code/bronchusevenmx/samples"
  filesystem:scan()
end

function filesystem:get_samples()
  return self.samples
end

function filesystem:get_sample_path()
  return self.sample_path
end

function filesystem:get_sample_name(index)
  return self.samples[index]
end

function filesystem:scandir(directory)
  local i, t, popen = 0, {}, io.popen
  local pfile = popen('ls -a "' .. directory .. '"')
  for filename in pfile:lines() do
    if filename ~= "." and filename ~= ".." then
      i = i + 1
      t[i] = filename
    end
  end
  pfile:close()
  return t
end

function filesystem:scan()
  local delete = {"LICENSE", "README.md"}
  local scan = util.scandir(self.sample_path)
  for k, file in pairs(scan) do
    for kk, d in pairs(delete) do
      local find = fn.table_find(scan, d)
      if find then table.remove(scan, find) end
    end
    local name = string.gsub(file, "/", "")
    table.insert(self.samples, name)
  end
end

return filesystem
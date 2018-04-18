def fixture(*name)
  File.read(File.join("spec", "fixtures", File.join(*name)))
end

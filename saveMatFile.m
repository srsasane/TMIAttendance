function saveMatFile(sMatFile,sBody)
if exist(sMatFile,'file') ~= 2
    cBody{1} = sBody;
    save(sMatFile,'cBody');
else
    load(sMatFile)
    cBody{end+1}=sBody;
    save(sMatFile,'cBody');
end
end
function saveMatFile(sMatFile,sBody,sCourseYear)
if exist(sMatFile,'file') ~= 2
    cBody{1} = sBody;
    save(sMatFile,'cBody','sCourseYear');
else
    load(sMatFile)
    cBody{end+1}=sBody;
    save(sMatFile,'cBody');
end
end
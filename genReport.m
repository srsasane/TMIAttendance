function mStudent = genReport(sME1,mStudent,sCourseName,n600)
for iStruct = 1:numel(sME1)
    if strcmpi(sME1(iStruct).name ,'.')
        continue;
    end
    if strcmpi(sME1(iStruct).name,'..')
        continue;
    end
    
   sFileName = fullfile(pwd,'MatData',sCourseName,sME1(iStruct).name);
   load(sFileName);
    for iCell =1:numel(cBody)
       sCourseYear = 'ME1';
    mStudent = updateAbsent(cBody,sCourseYear,mStudent,sFileName,n600);
    
    end
    
   
    [mStudent] = calculateScore(mStudent,n600);    
 
end
mStudent = calculatePercentage(mStudent,iStruct);



end
function mStudent = genReport(sStruct,mStudent,sCourseName,n600,handles)
for iStruct = 1:numel(sStruct)
    if strcmpi(sStruct(iStruct).name ,'.')
        continue;
    end
    if strcmpi(sStruct(iStruct).name,'..')
        continue;
    end
    
   sFileName = fullfile(pwd,'MatData',sCourseName,sStruct(iStruct).name);
   load(sFileName);
    for iCell =1:numel(cBody)
       
    mStudent = updateAbsent(cBody,sCourseName,mStudent,sFileName,n600);
    
    end
%     handles.mStudentb =mStudent;
%    set(handles.uitable5,'data',handles.mStudent)
    [mStudent] = calculateScore(mStudent,n600);    
 
end
mStudent = calculatePercentage(mStudent,iStruct);



end
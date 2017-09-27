function sCourseYear = courseName(vSubject)
cCourseYear = strcat(vSubject(1),vSubject(2));
sCourseYear = cell2str(cCourseYear);
sCourseYear = sCourseYear(3:end-3);
%% Adjust course name when DNS
if strcmpi(sCourseYear,'ME1')
    
    
elseif strcmpi(sCourseYear,'ME2')
    
elseif strcmpi(sCourseYear,'NS1')
    
elseif strcmpi(sCourseYear,'NS2')
    
elseif strcmpi(sCourseYear,'DNS1')    
    
else  
    sCourseYear=[sCourseYear(1:3),'1'];
end


end
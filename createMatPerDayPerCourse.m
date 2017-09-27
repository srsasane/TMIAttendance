function createMatPerDayPerCourse()
load('MailData.mat')
%% Delete old files

delete(fullfile(pwd,'MatData','ME1','*.*'))
delete(fullfile(pwd,'MatData','ME2','*.*'))
delete(fullfile(pwd,'MatData','NS1','*.*'))
delete(fullfile(pwd,'MatData','NS2','*.*'))
delete(fullfile(pwd,'MatData','DNS1','*.*'))
%%
% count = 1;
for iMail =1: nCount    
    sSubject =  mMailData{iMail,1};
    sBody = mMailData{iMail,2};
    C = textscan(sSubject,'%s','Delimiter',',');
    vSubject = cell (C{1,1});
    sCourseYear=   courseName(vSubject);
    
    if strcmp(vSubject(1),'DNS')
        if strcmp(vSubject(2),'1')
            sDate = datestr(datenum(vSubject(3),'dd/mm/yyyy'));
            sMatFile = fullfile(pwd,'MatData',sCourseYear,[sCourseYear,sDate,'.mat']);
            saveMatFile(sMatFile,sBody,sCourseYear);
        else
            sDate = datestr(datenum(vSubject(2),'dd/mm/yyyy'));
            sMatFile = fullfile(pwd,'MatData',sCourseYear,[sCourseYear,sDate,'.mat']);
            saveMatFile(sMatFile,sBody,sCourseYear);
        end
        
    else
        
        sDate = datestr(datenum(vSubject(3),'dd/mm/yyyy'));        
        sMatFile = fullfile(pwd,'MatData',sCourseYear,[sCourseYear,sDate,'.mat']);
        saveMatFile(sMatFile,sBody,sCourseYear); 
%         if strcmpi([sCourseYear,sDate],'ME120-JUL-2017')
%             disp(sSubject);
%             disp(sBody);
%             
%             fprintf('\n%s\n ==>\t %d \n',sMatFile,count);
%             count=count+1;
%         end
%         
    end  
end

end
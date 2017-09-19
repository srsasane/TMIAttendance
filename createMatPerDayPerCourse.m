function createMatPerDayPerCourse()
load('MailData.mat')
for iMail =1: nCount
    %        iMail =2021 +1; %DELETE ME
    %     break;
    sSubject =  mMailData{iMail,1};
    disp(sSubject);
    sBody = mMailData{iMail,2};
    C = textscan(sSubject,'%s','Delimiter',',');
    vSubject = cell (C{1,1});
    sCourseYear=   courseName(vSubject);
    
    if strcmp(vSubject(1),'DNS')
        if strcmp(vSubject(2),'1')
            sDate = datestr(datenum(vSubject(3),'dd/mm/yyyy'));
            sMatFile = fullfile(pwd,'MatData',sCourseYear,[sCourseYear,sDate,'.mat']);
            save(sMatFile,'sBody');
        else
            sDate = datestr(datenum(vSubject(2),'dd/mm/yyyy'));
            sMatFile = fullfile(pwd,'MatData',sCourseYear,[sCourseYear,sDate,'.mat']);
            save(sMatFile,'sBody');
        end
       
    else
        
        sDate = datestr(datenum(vSubject(3),'dd/mm/yyyy'));
        sMatFile = fullfile(pwd,'MatData',sCourseYear,[sCourseYear,sDate,'.mat']);
        save(sMatFile,'sBody');
        fprintf('Mail Processed %d/%d \n',iMail,nCount);
        fprintf('%s File created \n',sMatFile);
    end
    %% ----Create Individual mat file per date
    
    %     fprintf('\n mail processed %d \t',iMail)
end
end
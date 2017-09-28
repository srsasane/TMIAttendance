function mStudent = updateAbsent(cBody,sCourseName,mStudent,sFileName,n600)
vId = mStudent(:,1);
for iCell =1:numel(cBody)
 
    sBody = cBody{iCell};
    disp(sBody);
    C = textscan(sBody,'%s','Delimiter',',');
    vAbsent = cell(C{1,1});    
    nRow = 1;     
            %  vHourId = zeros(1,8);
      %  vHourColumn= zeros(1,8);
        %% Logic that adds attendance of time slot 0600
       % vHourColumn(1) = n600;
        
        if cellfun('isempty',mStudent(nRow,n600))
            % Mark all student present for 0600 hours class
           mStudent(nRow:end,n600)={1};
            
        end
%         nProcessed = 1+nProcessed;
        [v0830,v0930,v1040,v1140,v1340,v1440,v1540 ] = segregateAbsent(vAbsent);
        
        
        %% Logic to make student absent
        
        if ~isempty(v0830)
           mStudent(nRow:end,n600+1)={1};
            for iAbsent =2:numel(v0830)
                if strcmpi(v0830{iAbsent},'NIL')
                    break;
                end
                nIdx = findStudentID(vId,v0830{iAbsent});
                
               mStudent{nIdx,n600+1}=0;
            end
%             set(handles.uitable5,'data',handles.mStudent)
        end
        if ~isempty(v0930)
           mStudent(nRow:end,n600+2)={1};
            for iAbsent =2:numel(v0930)
                if strcmpi(v0930{iAbsent},'NIL')
                    break;
                end
                nIdx = findStudentID(vId,v0930{iAbsent});
               mStudent{nIdx,n600+2}=0;
            end
%             set(handles.uitable5,'data',handles.mStudent)
        end
        if ~isempty(v1040)
           mStudent(nRow:end,n600+3)={1};
            for iAbsent =2:numel(v1040)
                if strcmpi(v1040{iAbsent},'NIL')
                    break;
                end
                nIdx = findStudentID(vId,v1040{iAbsent});
               mStudent{nIdx,n600+3}=0;
            end
%             set(handles.uitable5,'data',handles.mStudent)
        end
        if ~isempty(v1140)
           mStudent(nRow:end,n600+4)={1};
            for iAbsent =2:numel(v1140)
                if strcmpi(v1140{iAbsent},'NIL')
                    break;
                end
                nIdx = findStudentID(vId,v1140{iAbsent});
               mStudent{nIdx,n600+4}=0;
            end
%             set(handles.uitable5,'data',handles.mStudent)
        end
        if ~isempty(v1340)
           mStudent(nRow:end,n600+5)={1};
            for iAbsent =2:numel(v1340)
                if strcmpi(v1340{iAbsent},'NIL')
                    break;
                end
                nIdx = findStudentID(vId,v1340{iAbsent});
               mStudent{nIdx,n600+5}=0;
            end
%             set(handles.uitable5,'data',handles.mStudent)
        end
        if ~isempty(v1440)
           mStudent(nRow:end,n600+6)={1};
            for iAbsent =2:numel(v1440)
                if strcmpi(v1440{iAbsent},'NIL')
                    break;
                end
                nIdx = findStudentID(vId,v1440{iAbsent});
               mStudent{nIdx,n600+6}=0;
            end
%             set(handles.uitable5,'data',handles.mStudent)
        end
        if ~isempty(v1540)
           mStudent(nRow:end,n600+7)={1};
            for iAbsent =2:numel(v1540)
                if strcmpi(v1540{iAbsent},'NIL')
                    break;
                end
                nIdx = findStudentID(vId,v1540{iAbsent});
               mStudent{nIdx,n600+7}=0;
            end
%             set(handles.uitable5,'data',handles.mStudent)
        end
        
        %     elseif
        
    end


end
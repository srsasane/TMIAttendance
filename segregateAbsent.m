function [v0830,v0930,v1040,v1140,v1340,v1440,v1540 ] = segregateAbsent(vAbsent)
v0830 = [];
v0930 = [];
v1040 = [];
v1140 = [];
v1340 = [];
v1440 = [];
v1540 = [];
for iHours = 1:size(vAbsent,1)
    if strcmp(vAbsent(iHours),'0830')
        sHourID = vAbsent(iHours);
    elseif strcmp(vAbsent(iHours),'0930')
        sHourID = vAbsent(iHours);
    elseif strcmp(vAbsent(iHours),'1040')
        sHourID = vAbsent(iHours);
    elseif strcmp(vAbsent(iHours),'1140')
        sHourID = vAbsent(iHours);
    elseif strcmp(vAbsent(iHours),'1340')
        sHourID = vAbsent(iHours);
    elseif strcmp(vAbsent(iHours),'1440')
        sHourID = vAbsent(iHours);
    elseif strcmp(vAbsent(iHours),'1540')
        sHourID = vAbsent(iHours);
    elseif strcmp(vAbsent(iHours),'1240')
        
        error('Wrong HourID !!')
        
    end
    if strcmp(sHourID,'0830')
        if strcmp(vAbsent(iHours),'0830')
            
            idx0830 = 1;
        end
        v0830{idx0830} = vAbsent(iHours);
        idx0830 = idx0830+1;
    elseif strcmp(sHourID,'0930')
        if strcmp(vAbsent(iHours),'0930')
            
            idx0930 = 1;
        end
        v0930{idx0930} = vAbsent(iHours);
        idx0930 = idx0930+1;
    elseif strcmp(sHourID,'1040')
        if strcmp(vAbsent(iHours),'1040')
            
            idx1040 = 1;
        end
        v1040{idx1040} = vAbsent(iHours);
        idx1040 = idx1040+1;
    elseif strcmp(sHourID,'1140')
        if strcmp(vAbsent(iHours),'1140')
            
            idx1140 = 1;
        end
        v1140{idx1140} = vAbsent(iHours);
        idx1140 = idx1140 +1;
        
    elseif strcmp(sHourID,'1340')
        if strcmp(vAbsent(iHours),'1340')
            
            idx1340 =1;
        end
        v1340{idx1340} = vAbsent(iHours);
        idx1340 = idx1340+1;
    elseif strcmp(sHourID,'1440')
        if strcmp(vAbsent(iHours),'1440')
            
            idx1440 = 1;
        end
        v1440{idx1440} = vAbsent(iHours);
        idx1440 = idx1440+1;
    elseif strcmp(sHourID,'1540')
        if strcmp(vAbsent(iHours),'1540')
            
            idx1540 = 1;
        end
        v1540{idx1540} = vAbsent(iHours);
        idx1540 = idx1540 +1;
    end
end
end
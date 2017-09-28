function mStudent = calculatePercentage(mStudent,nDays)

vScore = cell2mat(mStudent(:,end));
vScore = vScore./((nDays-2));
vScore = vScore.*100;
mStudent(:,end) = num2cell(vScore);
end
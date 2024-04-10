%% Task 1-2

% ������� ����� � Workspace
clc
clear

% ��������� �������
NIOT = readmatrix("AUS_niot_nov16.xlsx", 'Range', 'E3:BF56');
finalConsumption = readmatrix("AUS_niot_nov16.xlsx", 'Range', 'BI3:BM56');
totalOutput = readmatrix("AUS_niot_nov16.xlsx", 'Range', 'BO3:BO56');

disp('task 1 complited');

% ��������� � ������������ ������ (�� ������ ��� � ������������� ������)
NIOT = NIOT.*1.34;
finalConsumption = finalConsumption.*1.34;
totalOutput = totalOutput.*1.34;

disp('task 2 complited');
%% Task 3

% ������� ������ ������
directCosts = NIOT; 

% ������� ��� ������� ������� directCosts
ind = find(sum(directCosts,1)==0) ;
directCosts(:,ind) = [] ;

% ������� ��� ������� ������ directCosts
ind = find(sum(directCosts,2)==0) ;
directCosts(ind,:) = [] ;

% ������� ������
x = totalOutput;
x(x==0)=[];

% ������� ���� ������ ������ �� ������� ������ ������
A = directCosts./x;

% ������ ����������������� �����������
Ax = A*x;

% ���������� � ������� ������� ��������� �������
finalConsumption = sum(finalConsumption, 2);

% ������ ��������� �����������
w = finalConsumption;
w(w==0)=[];

% ������������ �������
Ax_plus_w = Ax+w;

% �������� �� �������������� (�������� ������� �������)
isProductive = 1;
for i = 1:size(A,1)
   if(det(A(1:i,1:i)) == 0)
       isProductive = 0;
   end
end
if isProductive
    disp('A is productive');
else
    disp('A is not Productive');
end

% ������� ��������� ����������
clear ind i isProductive
disp('task 3 complited');
%% Task 4

% ������� ����������� ������ � �����
[eigenVec,eigenNum] = eig(A);

% ������� ������ � ����� ����������-�������
DiagEigenNum = diag(eigenNum);
[FPNum,FPInd] = max(DiagEigenNum);
FPVec = eigenVec(1:size(eigenVec,2,FPInd))';

% ���������, ��������� �� ��������� ����� ����������-�������
lambda = FPNum.*eye(size(A));
error = (A-lambda)*FPVec;

% ������� ��������� ����������
clear DiagEigenNum FPInd
clear eigenVec eigenNum
clear lambda error
disp('task 4 complited');
%% Task 5

% ������� ������ A, B, C...
MacroBranches = [3, 1, 18, 1, 2, 1, 3, 5, 1, 4, 3, 1, 1, 1, 1, 1, 1, 1];

% ������� ������� �� ������ ������ A, B, C...
Indexes = cumsum(MacroBranches);

% ���������� �������
Included = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
MBnew = MacroBranches.*Included;
MBnew(MBnew == 0) = [];

% ���������� �������
ID2 = Indexes.*Included;
ID2(ID2 == 0) = [];

ID1 = ID2-MBnew+1;

% �������� ������ ��� A, x, w
AggA = zeros(size(MBnew));
Aggx = zeros(size(MBnew,1));
Aggw = zeros(size(MBnew,1));

% ��� ���� ������ � �������� ��������� A x w
for l = 1:size(MBnew,2)
    for k = 1:size(MBnew,2)
        tempDC = directCosts(ID1(k):ID2(k), ID1(l):ID2(l));
        tempX = x(ID1(l):ID2(l));
        AggA(k,l) =  sum(sum((tempDC)));
        Aggx(l) = sum(tempX);
    end
    Aggw(l) = sum(w((ID1(l):ID2(l))));
end

% ������������� ������� x w
Aggx = Aggx';
Aggw = Aggw';

% �������������� �������
B = AggA./Aggx;
Bx = B*Aggx;
Bx_plus_w = Bx+Aggw;

% �������� �� �������������� (�������� ������� �������)
isProductive = 1;
for i = 1:size(B,1)
   if(det(B(1:i,1:i)) == 0)
       isProductive = 0;
   end
end
if isProductive
    disp('B is productive');
else
    disp('B is not Productive');
end

% ������� ��������� ����������
clear MacroBranches Indexes Included MBnew l k i isProductive
clear ID1 ID2
clear tempDC  tempX
disp('task 5 complited');
%% Task 6

% ������� ����������� ������ � �����
[AggEigenVec,AggEigenNum] = eig(B);

% ������� ������ � ����� ����������-�������
AggDEigenNum = diag(AggEigenNum);
[AggFPNum,AggFPInd] = max(AggDEigenNum);
AggFPVec = AggEigenVec(1:size(AggEigenVec,2,AggFPInd))';

% ��������� ��������� �� ��������� ����� ����������-�������
AggLambda = AggFPNum.*eye(size(B));
AggError = (B-AggLambda)*AggFPVec;

% ������� ��������� ����������
clear AggEigenVec AggEigenNum
clear AggDEigenNum AggFPInd
clear AggLambda AggError
disp('task 6 complited');
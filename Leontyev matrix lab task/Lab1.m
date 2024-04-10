%% Task 1-2

% Очищаем экран и Workspace
clc
clear

% Загружаем таблицу
NIOT = readmatrix("AUS_niot_nov16.xlsx", 'Range', 'E3:BF56');
finalConsumption = readmatrix("AUS_niot_nov16.xlsx", 'Range', 'BI3:BM56');
totalOutput = readmatrix("AUS_niot_nov16.xlsx", 'Range', 'BO3:BO56');

disp('task 1 complited');

% Переводим в национальную валюту (из доллар США в австралийский доллар)
NIOT = NIOT.*1.34;
finalConsumption = finalConsumption.*1.34;
totalOutput = totalOutput.*1.34;

disp('task 2 complited');
%% Task 3

% матрица прямых затрат
directCosts = NIOT; 

% Удаляем все нулевые столбцы directCosts
ind = find(sum(directCosts,1)==0) ;
directCosts(:,ind) = [] ;

% Удаляем все нулевые строки directCosts
ind = find(sum(directCosts,2)==0) ;
directCosts(ind,:) = [] ;

% Валовый выпуск
x = totalOutput;
x(x==0)=[];

% Матрица коэф прямых затрат из матрицы прямых затрат
A = directCosts./x;

% Вектор внутриотраслевого потребления
Ax = A*x;

% Складываем к первому столбцу остальные столбцы
finalConsumption = sum(finalConsumption, 2);

% Вектор конечного потребления
w = finalConsumption;
w(w==0)=[];

% Потребляемые выпуски
Ax_plus_w = Ax+w;

% Проверка на продуктивность (критерий главных миноров)
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

% Удаляем временные переменные
clear ind i isProductive
disp('task 3 complited');
%% Task 4

% Находим собственный вектор и число
[eigenVec,eigenNum] = eig(A);

% Находим вектор и числа Фробениуса-Перрона
DiagEigenNum = diag(eigenNum);
[FPNum,FPInd] = max(DiagEigenNum);
FPVec = eigenVec(1:size(eigenVec,2,FPInd))';

% Проверяем, правильно ли вычислены числа Фробениуса-Перрона
lambda = FPNum.*eye(size(A));
error = (A-lambda)*FPVec;

% Удаляем временные переменные
clear DiagEigenNum FPInd
clear eigenVec eigenNum
clear lambda error
disp('task 4 complited');
%% Task 5

% Размеры матриц A, B, C...
MacroBranches = [3, 1, 18, 1, 2, 1, 3, 5, 1, 4, 3, 1, 1, 1, 1, 1, 1, 1];

% Смещаем индексы на размер матриц A, B, C...
Indexes = cumsum(MacroBranches);

% Подключаем матрицы
Included = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
MBnew = MacroBranches.*Included;
MBnew(MBnew == 0) = [];

% Подключаем индексы
ID2 = Indexes.*Included;
ID2(ID2 == 0) = [];

ID1 = ID2-MBnew+1;

% Выделяем память для A, x, w
AggA = zeros(size(MBnew));
Aggx = zeros(size(MBnew,1));
Aggw = zeros(size(MBnew,1));

% Для всех матриц и индексов заполняем A x w
for l = 1:size(MBnew,2)
    for k = 1:size(MBnew,2)
        tempDC = directCosts(ID1(k):ID2(k), ID1(l):ID2(l));
        tempX = x(ID1(l):ID2(l));
        AggA(k,l) =  sum(sum((tempDC)));
        Aggx(l) = sum(tempX);
    end
    Aggw(l) = sum(w((ID1(l):ID2(l))));
end

% Транспонируем вектора x w
Aggx = Aggx';
Aggw = Aggw';

% Агрегированная матрица
B = AggA./Aggx;
Bx = B*Aggx;
Bx_plus_w = Bx+Aggw;

% Проверка на продуктивность (критерий главных миноров)
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

% Удаляем временные переменные
clear MacroBranches Indexes Included MBnew l k i isProductive
clear ID1 ID2
clear tempDC  tempX
disp('task 5 complited');
%% Task 6

% Находим собственный вектор и число
[AggEigenVec,AggEigenNum] = eig(B);

% Находим вектор и числа Фробениуса-Перрона
AggDEigenNum = diag(AggEigenNum);
[AggFPNum,AggFPInd] = max(AggDEigenNum);
AggFPVec = AggEigenVec(1:size(AggEigenVec,2,AggFPInd))';

% Проверяем правильно ли вычислены числа Фробениуса-Перрона
AggLambda = AggFPNum.*eye(size(B));
AggError = (B-AggLambda)*AggFPVec;

% Удаляем временные переменные
clear AggEigenVec AggEigenNum
clear AggDEigenNum AggFPInd
clear AggLambda AggError
disp('task 6 complited');
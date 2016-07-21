addpath(genpath('ieeg-matlab-1.13.2'));

% Gathering the data
session = IEEGSession('I521_A0007_D001', 'jayjung1018', 'jay_ieeglogin.bin');
session2 = IEEGSession('I521_A0007_D002', 'jayjung1018', 'jay_ieeglogin.bin');

% Computing the R Matrix
data = zeros(40, 1991);
M = 1972;
N = 20;
v = 40;
columns = 801;

%store data
for i = 1:40
    data(i, :) = session.data.getvalues(1:1991, i);
end

%initialize R matrix
R = zeros(M, columns);

%set the first column to 1
R(1:end, 1) = 1;
start = 1;

%fill in 20 elements at a time
for i = 1:M
   for j = 1:40
       index = 2 + (j-1) * 20;
       R(i, index:index + 19) = data(j, start:start + 19);
   end
   start = start + 1;
end

meanOfR = mean(mean(R))

%% 
% <latex> 
%  \item Calculate the linear filter (i.e. the weights vector) $\mathbf{f}$ as defined by Equation 1 for the X position and then for the Y position. (Note: instead of using the matrix inverse of $\mathbf{R}^T\mathbf{R}$, use Matlab \texttt{mldivide} function, which is generally more stable.) 
%  \begin{enumerate}
% \item Reshape the weights, excluding the first (bias) weight, into a $40 \times 20$ matrix and show it with \verb|imagesc| with time bins on the x-axis and different cells on the y-axis. Make sure to include a \verb|colorbar| with each image. (4 pts)
% </latex> 

%%
RT = R.';
I = eye(801, 801);
RTR = RT * R;

MonkeyX = session2.data.getvalues(1:M, 1);
MonkeyY = session2.data.getvalues(1:M, 2);

f_x = mldivide(RTR, I) * (RT * MonkeyX);
f_y = mldivide(RTR, I) * (RT * MonkeyY);

f_xRe = zeros(40, 20);
f_yRe = zeros(40, 20);

%%
R_test = R(1:400, :);
R_train = R(401:end, :);

X_test = MonkeyX(1:400);
X_train = MonkeyX(401:end);

Y_test = MonkeyY(1:400);
Y_train = MonkeyY(401:end);

RT_train = R_train';
I = eye(801, 801);
RTR_train = RT_train * R_train;

f_xtrain = mldivide(RTR_train, I) * (RT_train * X_train);
f_ytrain = mldivide(RTR_train, I) * (RT_train * Y_train);

u_xtrain = R_train * f_xtrain;
u_ytrain = R_train * f_ytrain;

u_xtest = R_test * f_xtrain;
u_ytest = R_test * f_ytrain;

corr_xtrain = corr(X_train, u_xtrain)
corr_ytrain = corr(Y_train, u_ytrain)

corr_xtest = corr(X_test, u_xtest)
corr_ytest = corr(Y_test, u_ytest)

figure();
for i = 1:length(u_xtest)
    plot(u_xtest(i), u_ytest(i), 'bo', X_test(i), Y_test(i), 'r.');
    axis([8000 12000 12000 16000]);
    title('X/Y actual and predicted positions');
    xlabel('X position');
    ylabel('Y position');
    legend('Predicted', 'Actual');
    pause(0.035);
end
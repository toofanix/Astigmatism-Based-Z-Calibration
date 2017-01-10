%%
%Created by Jigar N. Bandaria. 3/10/14.
% All the saved traces are duplicated and plotted for comparision.
%%

figure(8)
tempx_x=savedx_x;
tempx_y=savedx_y;
tempy_y=savedy_y;
tempy_x=savedy_x;
fit_param_x2=fit_param_x;
fit_param_y2=fit_param_y;
for i=1:length(tempx_x)
    subplot(1,2,1)
    plot(tempx_x{1,i},tempx_y{1,i});
    hold on;
    plot(tempy_x{1,i},tempy_y{1,i},'r');
end
hold off
%--------------------------------------------------------------------------
%Traces whose widths are larger than 3 pixels are removed. Our pixel width
%is 120 nm.
%First checking Wx traces.
cellx_min=cellfun(@min,tempx_y);
index_cellx_min=find(cellx_min>3*120)
tempx_y(:,index_cellx_min)=[];
tempx_x(:,index_cellx_min)=[];
tempy_y(:,index_cellx_min)=[];
tempy_x(:,index_cellx_min)=[];
fit_param_x2(index_cellx_min,:)=[];
fit_param_y2(index_cellx_min,:)=[];

%Checking Wy traces.
celly_min=cellfun(@min,tempy_y);
index_celly_min=find(celly_min>3*120)
tempx_y(:,index_celly_min)=[];
tempx_x(:,index_celly_min)=[];
tempy_y(:,index_celly_min)=[];
tempy_x(:,index_celly_min)=[];
fit_param_x2(index_celly_min,:)=[];
fit_param_y2(index_celly_min,:)=[];


%--------------------------------------------------------------------------
%Plotting the remaining traces.
%figure(9)
for i=1:length(tempx_x)
    subplot(1,2,2)
    plot(tempx_x{1,i},tempx_y{1,i},'b.');
    hold on;
    plot(tempy_x{1,i},tempy_y{1,i},'r.');
end
hold off
%--------------------------------------------------------------------------
%Saving the Fitted parameters for Wx and Wy
save ('Wx_parameters.txt', 'fit_param_x2','-ascii');
save ('Wy_parameters.txt', 'fit_param_y2','-ascii');

%--------------------------------------------------------------------------
%{
%Doing a non-linear regression fit to all the curves at the same time.
tempx_x_1=cellfun(@transpose,tempx_x,'UniformOutput',false);
tempx_y_1=tempx_y;
tempx_x_2=cat(1,tempx_x_1{:});
tempx_y_2=cat(1,tempx_y_1{:});
%figure (10)
subplot(1,3,3),scatter(tempx_x_2,tempx_y_2);


%Functional form of the fit. Works but gives a bad fit.
ftype1 = fittype('w0*sqrt( ((z-g)/zr)^2 + 1 ) ','coeff', {'w0','zr','g'},'ind','z');
ftype2 = fittype('w0*sqrt( C*((z-g)/zr)^5+B*((z-g)/zr)^4 + A*((z-g)/zr)^3 + ((z-g)/zr)^2 + 1 )','coeff', {'w0','zr','g','A','B','C'},'ind','z');
fopt = fitoptions('Method','NonlinearLeastSquares','Lower',[ 200   200   -400 ],'Upper',[ 400   600   100 ],'StartPoint',[ 344,334,-191,0.0,0.0]);  
fresx1 = fit(tempx_x_2,tempx_y_2,ftype1,'start',[ 300  450  -240 ]);  
fopt = fitoptions('Method','NonlinearLeastSquares','Lower',[ 200   200   -400  -1 -1 -1],'Upper',[ 400   600   -100  1 5 2]);
fresx3 = fit(tempx_x_2,tempx_y_2,ftype2,'start',[ fresx1.w0  fresx1.zr  fresx1.g  0 0 0])
figure (10)
plot(fresx3,tempx_x_2,tempx_y_2)
%}

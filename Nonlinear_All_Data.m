%Doing a non-linear regression fit to all the curves at the same time.
tempx_x_1=cellfun(@transpose,tempx_x,'UniformOutput',false);
tempx_y_1=tempx_y;
tempx_x_2=cat(1,tempx_x_1{:});
tempx_y_2=cat(1,tempx_y_1{:});

tempy_x_1=cellfun(@transpose,tempy_x,'UniformOutput',false);
tempy_y_1=tempy_y;
tempy_x_2=cat(1,tempy_x_1{:});
tempy_y_2=cat(1,tempy_y_1{:});

%figure (10)
scatter(tempx_x_2,tempx_y_2);hold on;scatter(tempy_x_2,tempy_y_2);hold off


%Functional form of the fit.
ftype1 = fittype('w0*sqrt( ((z-g)/zr)^2 + 1 ) ','coeff', {'w0','zr','g'},'ind','z');
ftype2 = fittype('w0*sqrt( C*((z-g)/zr)^5+B*((z-g)/zr)^4 + A*((z-g)/zr)^3 + ((z-g)/zr)^2 + 1 )','coeff', {'w0','zr','g','A','B','C'},'ind','z');
fopt = fitoptions('Method','NonlinearLeastSquares','Lower',[ 200   200   -400 ],'Upper',[ 500   600   400 ],'StartPoint',[ 344,334,-191,0.0,0.0]);  
fresx1 = fit(tempx_x_2,tempx_y_2,ftype1,'start',[ 300  450  -240 ]);  
fopt = fitoptions('Method','NonlinearLeastSquares','Lower',[ 200   200   -400  -1 -1 -1],'Upper',[ 500   600   -400  1 5 2]);
fresx3 = fit(tempx_x_2,tempx_y_2,ftype2,'start',[ fresx1.w0  fresx1.zr  fresx1.g  0 0 0])
figure (10)
plot(fresx3,tempx_x_2,tempx_y_2);hold on;

ftype3 = fittype('w01*sqrt( ((z-g1)/zr1)^2 + 1 ) ','coeff', {'w01','zr1','g1'},'ind','z');
ftype4 = fittype('w01*sqrt( C1*((z-g1)/zr1)^5+B1*((z-g1)/zr1)^4 + A1*((z-g1)/zr1)^3 + ((z-g1)/zr1)^2 + 1 )','coeff', {'w01','zr1','g1','A1','B1','C1'},'ind','z');
fopt = fitoptions('Method','NonlinearLeastSquares','Lower',[ 200   200   -400 ],'Upper',[ 400   600   100 ],'StartPoint',[ 344,334,-191,0.0,0.0]);  
fresy1 = fit(tempy_x_2,tempy_y_2,ftype3,'start',[ 300  450  -240 ]);  
fopt = fitoptions('Method','NonlinearLeastSquares','Lower',[ 200   200   -400  -1 -1 -1],'Upper',[ 400   600   -100  1 5 2]);
fresy3 = fit(tempy_x_2,tempy_y_2,ftype4,'start',[ fresy1.w01  fresy1.zr1  fresy1.g1  0 0 0])

plot(fresy3,tempy_x_2,tempy_y_2)

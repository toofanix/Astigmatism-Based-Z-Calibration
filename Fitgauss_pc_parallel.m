%%
%Written by Jigar Bandaria
%Performing 2D Gaussian fit on each candidate spot for all the 1000 frames
%%
tic
clear data5
clear fitspotx fitspoty
disp('WAIT. Doing Gaussian Fits to Beads.')
for f_count=1:999
clear fitspot 
disp(f_count)
data3=rot90(reshape(data2((f_count*t_pixel+1):(f_count+1)*t_pixel),xpixel,ypixel),2);
%parpool(3)
for i=1:length(pk)
spot1=data3(pk(i,2)-6:pk(i,2)+6,pk(i,1)-6:pk(i,1)+6);
[amp,ind]=max(spot1(:));
[mx0,ny0]=ind2sub(size(spot1),ind);
spot2=double(spot1);
xsd=3;ysd=3;back=600;%eastimate for stdev and background
[X,Y]=meshgrid(1:13);
xdata=zeros(size(X,1),size(Y,2),2);
xdata(:,:,1)=X;
xdata(:,:,2)=Y;
x0=[amp;mx0;xsd;ny0;ysd;back];%initial guesses
x0=double(x0);
lb=[1000,1,1,1,1,500];%lower bound
ub=[16500,15,7,15,7,16000];%upper bound
options = optimset( 'Display','off','TolFun', 1e-1, 'TolX', 1e-1);
[x,resnorm,residual,exitflag]=lsqcurvefit(@D2GaussFunction_2,x0,xdata,spot2,lb,ub,options);
fitspot(i,:)=[x(3,1);x(5,1)];
%[x,resnorm,residual,exitflag]=lsqcurvefit(@D2GaussFunction,x0,xdata,spot2,lb,ub);
out1=D2GaussFunction(x,xdata);
end
fitspotx(f_count,:)=fitspot(:,1);
fitspoty(f_count,:)=fitspot(:,2);
end
toc

%--------------------------------------------------------------------------
figure(1)
for i=1:size(fitspotx,2)
    plot(fitspotx(:,i));
    hold on
end
hold off
figure(2)
for i=1:size(fitspotx,2)
    plot(fitspoty(:,i));
    hold on
end
hold off
disp('DONE')
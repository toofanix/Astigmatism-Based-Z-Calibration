%%
%Written by Jigar Bandaria
% This script tried to do particle picking that can be used
% for z calibration. Points should have an amplitude of >200
% They should be 15 pixels aways from each other and edges.

clear FileName PathName data1 fbytes idx name1 nframes
sigma=2;
siz=5;

% Make 2D Gaussian kernel and Box Kernel
Gker = fspecial('gaussian',[siz siz],sigma);
Gker = Gker/sum(Gker(:));
Bker= ones(1,length(-round(siz+3):round(siz+3)));
Bker = Bker/sum(Bker(:));
data4_1=imfilter(imfilter(data3,Gker,'same','replicate'),Gker','same','replicate');
data4_2=imfilter(imfilter(data3,Bker,'same','replicate'),Bker','same','replicate');
data5=data4_1-data4_2;
%--------------------------------------------------------------------------

figure; 
subplot(1,2,1),imshow(data3,[])
hold on
pk=pkfnd(data5,200,3);
pk1=pk;
sortrows(pk);
scatter(pk(:,1),pk(:,2));
hold off
m=length(pk(:,1));
j=1;
%--------------------------------------------------------------------------
%Making sure that the spots are atleast 15 pixels apart.
while j < m 
X=pk(:,1); Y=pk(:,2);
X1=(X-X(j)).^2;
Y1=(Y-Y(j)).^2;
S=sqrt(X1+Y1);
b=find(0<S & S<10);%points have to be 15 pixels apart
if(~isempty(b))
       pk([b],:)=[];
       m=m-2;
       disp(m)
end
j=j+1;
end

%--------------------------------------------------------------------------

border=find((pk>504 & pk<512) |(pk>1 & pk<9)); %point aways from edges
m=0;
for i=1:length(border)
    
    [i1,i2]=ind2sub(size(pk),border(i)-m);
    disp(i1)
    pk((i1),:)=[];
    m=m+1;
end
m=length(pk); i=1;
while (i<m)
   if (data3(pk(i,2),pk(i,1))<1000)
      pk(i,:)=[];
      m=m-1;
   end
   i=i+1;
end
%--------------------------------------------------------------------------

picked_spots=data3;
%plotting the candidates on the middle frame
subplot(1,2,2),imshow(data3,[])
 hold on
scatter(pk(:,1),pk(:,2));
[~,idx1]=ismember(pk1(:,1),pk(:,1));
indx2=find(idx1==0);
pkr=pk1(indx2,:);
scatter(pkr(:,1),pkr(:,2),'r');
hold off
save ('pk_list.txt', 'pk','-ascii');
clear Bker Gker S X X1 Y Y1 b data4_1 data4_2 f_count %border
clear i i1 i2 idx1 indx2 j m sigma siz pk1 
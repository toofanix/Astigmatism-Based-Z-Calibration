%%
%Created by Jigar N. Bandaria. 3/9/14. 
%Run the scripts in following order
% 1. DAXimage
% 2. pklist
% 3. Fitgauss_pc_parallel
% 4. Fit_traces  
% 5. Confirm_fits and
% 6. Nonlinear_All_Data.m
%%
% Here I am indicating the file and getting info about the images
clear all
clc
%Getting the Filename and the Path. Will open a popup window looking for
%inf file.
[FileName,PathName] = uigetfile('*.inf','Select the MATLAB code file');

%opens the file and gets the number of frames and dimesnions of the frame.
%it will also calculate total number of pixels in a frames and the size of
%the image in bytes.
fid=fopen(FileName);
for i=1:2
tline=fgetl(fid);
disp (tline);
end
%--------------------------------------------------------------------------
C = textscan(tline,'%s');%this creates a 1X1 cell
data=cellstr(C{1});%data in string format is read from the cell
nframes=str2num(char(data(5)))%this is the number of frames.
%--------------------------------------------------------------------------
for i=1:2
tline=fgetl(fid);
disp (tline);
end
C = textscan(tline,'%s');
data=cellstr(C{1});
xpixel=str2num(char(data(4)));
ypixel=str2num(char(data(6)));
t_pixel=xpixel*ypixel;
fclose(fid);
fbytes=t_pixel*2;
clear C data i tline fid ans;
%--------------------------------------------------------------------------
%loading the dax file that has the same name but with an inf
%extension and then loading the first frame.
idx = strfind(FileName,'.')
FileName(idx+1:end)=[]
name1=strcat(FileName,'dax')
data1=fopen(name1,'r');
data2=fread(data1,inf,'int16=>uint16',0, 'ieee-be');%reading all data
f_count=500;%frame # to read
data3=rot90(reshape(data2((f_count*t_pixel+1):(f_count+1)*t_pixel),xpixel,ypixel),2);
%J=imadjust(data3);
avg_img=sum(reshape(data2,xpixel,ypixel,nframes),3)/nframes;
imshow(data3,[])
%plotting the middle frame to get an idea where the fluorescent spots are.

function [BasicImage]=main()
close all
RawDataWithPhantom=imread('(3680- 20 cm GRID1) -165.tif');
RawDataWoPhantom=imread('(3680-GRID1 air).tif');
% figure(1)
% subplot(1,2,1)
% imagesc(RawDataWithPhantom); colormap('gray')
% subplot(1,2,2)
% imagesc(RawDataWoPhantom); colormap('gray')
figure(2)

DataWoPhantom=RawDataWoPhantom-min(min(RawDataWoPhantom));
DataWithPhantom=RawDataWithPhantom-min(min(RawDataWithPhantom));
TempImage=-(DataWithPhantom-DataWoPhantom*(max(max(DataWithPhantom)))/(max(max(DataWoPhantom))));
imagesc(TempImage); colormap('gray')
temp=round(ginput());
minX=min(temp(:,1));
maxX=max(temp(:,1));
minY=min(temp(:,2));
maxY=max(temp(:,2));
xlim([minX maxX]); ylim([minY,maxY])
NonScaledNewImage=TempImage(minY:maxY,minX:maxX);
BasicImage=(NonScaledNewImage-min(min(NonScaledNewImage)))/max(max(NonScaledNewImage-min(min(NonScaledNewImage))));
figure(3)
imagesc(BasicImage); colormap('gray')

figure(4)
% imagesc(wiener2(NewImage,[18 18]));colormap('gray')
SumofColumns=sum(BasicImage,1)/(maxY-minY);
RuvenProposedImage=BasicImage./(ones(size(BasicImage,1),1)*SumofColumns); % Equal the sum of all image columns
VerifyFlag=max(abs(sum(RuvenProposedImage,1)/(maxY-minY)-1))<1e-3;
if VerifyFlag
    subplot(1,2,1)
    imagesc(BasicImage); colormap('gray')
    title('Basic Image')
    subplot(1,2,2)
    imagesc(RuvenProposedImage); colormap('gray')
    title('Proposed Algorithm')
else
    warning('That wasnt the idea')
end

ProfileAnalysisFlag=0;
if ProfileAnalysisFlag 
% Profile Analysis
    figure(3); temp=round(ginput()); figure(5); 
    hold all; plot(BasicImage(temp(2),:),'r')
    figure(3); temp=round(ginput()); figure(5);
    hold all; plot(BasicImage(temp(2),:),'g'); 
    figure(3); temp=round(ginput()); figure(5);
    hold all; plot(BasicImage(temp(2),:),'b');
end
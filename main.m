function [BasicImageStatistics,ElaboratedImageStatistics]=main()
close all
RawData=imread('images\(3680- 20 cm GRID1) -165 normal by GRID profile.tif');
figure(1)
imagesc(RawData); colormap('gray')
[BasicImage,BasicImageStatistics]=CropData(RawData);
[ElaboratedImage1]=AverageOnColumns(BasicImage);
[ElaboratedImage2]=AverageOnRows(ElaboratedImage1);



ElaboratedImageStatistics=FindStatistics(ElaboratedImage2);

VerifyFlag=max(abs(sum(ElaboratedImage1,1)/(size(BasicImage,2))-1))<1e-3;
if VerifyFlag
    subplot(1,3,1)
    imagesc(BasicImage); colormap('gray')
    title('Basic Image')
    subplot(1,3,2)
    imagesc(ElaboratedImage1); colormap('gray')
    title('Proposed Algorithm on Columns')
    subplot(1,3,3)
    imagesc(ElaboratedImage2); colormap('gray')
    title('Proposed Algorithm on Columns and Rows')
else
    warning('That wasnt the idea')
end

g=3;

function [BasicImage,statistics]=CropData(RawData)
temp=round(ginput());
minX=min(temp(:,1));
maxX=max(temp(:,1));
minY=min(temp(:,2));
maxY=max(temp(:,2));
xlim([minX maxX]); ylim([minY,maxY])
NonScaledNewImage=RawData(minY:maxY,minX:maxX);
BasicImage=(NonScaledNewImage-min(min(NonScaledNewImage)))/max(max(NonScaledNewImage-min(min(NonScaledNewImage))));
statistics=FindStatistics(BasicImage);
figure
imagesc(BasicImage); colormap('gray')

function [ElaboratedImage]=AverageOnColumns(BasicImage)

SumofColumns=sum(BasicImage,1)/size(BasicImage,2);
ElaboratedImage=BasicImage./(ones(size(BasicImage,1),1)*SumofColumns); % Equal the sum of all image columns

function [ElaboratedImage]=AverageOnRows(BasicImage)
SumofRows=sum(BasicImage,2)/size(BasicImage,1);
ElaboratedImage=BasicImage./(SumofRows*ones(1,size(BasicImage,2))); % Equal the sum of all image columns

function statistics=FindStatistics(Image)
if isempty(Image)
    statistics=[];
    return
end
statistics(1)=mean(Image(:));
statistics(2)=std(Image(:));
statistics(3)=statistics(2)/statistics(1);

% ProfileAnalysisFlag=0;
% if ProfileAnalysisFlag 
% % Profile Analysis
%     figure(3); temp=round(ginput()); figure(5); 
%     hold all; plot(BasicImage(temp(2),:),'r')
%     figure(3); temp=round(ginput()); figure(5);
%     hold all; plot(BasicImage(temp(2),:),'g'); 
%     figure(3); temp=round(ginput()); figure(5);
%     hold all; plot(BasicImage(temp(2),:),'b');
% end
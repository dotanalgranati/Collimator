function [BasicImageStatistics,ElaboratedImageStatistics]=main()
close all
RawData=imread('images\(3680- 20 cm GRID1) -165 normal by GRID profile.tif');
figure(1)
imagesc(RawData); colormap('gray')
[BasicImage,BasicImageStatistics]=CropData(RawData);
AverageOverXRows=99;
AverageOverXColumns=99;
RowsMargin=floor(AverageOverXRows/2);
ElaboratedImage1=BasicImage;
for row=RowsMargin+1:size(BasicImage,1)-RowsMargin
    TempImage=AverageOnColumns(BasicImage(row-RowsMargin:row+RowsMargin,:));
    ElaboratedImage1(row,:)=TempImage(RowsMargin+1,:);
end
ColumnsMargin=floor(AverageOverXColumns/2);
ElaboratedImage2=BasicImage;
for column=ColumnsMargin+1:size(BasicImage,2)-ColumnsMargin
    TempImage=AverageOnRows(BasicImage(:,column-ColumnsMargin:column+ColumnsMargin));
    ElaboratedImage2(:,column)=TempImage(:,ColumnsMargin+1);
end
ElaboratedImage3=ElaboratedImage1;
for column=ColumnsMargin+1:size(ElaboratedImage1,2)-ColumnsMargin
    TempImage=AverageOnRows(ElaboratedImage1(:,column-ColumnsMargin:column+ColumnsMargin));
    ElaboratedImage3(:,column)=TempImage(:,ColumnsMargin+1);
end
% [ElaboratedImage2,success_flag1]=AverageOnColumns(BasicImage);
% % [ElaboratedImage2,success_flag2]=AverageOnRows(ElaboratedImage1);
ElaboratedImage1=RemoveMargins(ElaboratedImage1,RowsMargin,0);
ElaboratedImage2=RemoveMargins(ElaboratedImage2,0,ColumnsMargin);
ElaboratedImage3=RemoveMargins(ElaboratedImage3,RowsMargin,ColumnsMargin);

ElaboratedImageStatistics=FindStatistics(ElaboratedImage3);
PlotResults(BasicImage,ElaboratedImage1,ElaboratedImage2,ElaboratedImage3);


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

function [ElaboratedImage,VerifyFlag]=AverageOnColumns(BasicImage)

SumofColumns=sum(BasicImage,1)/size(BasicImage,1);
ElaboratedImage=BasicImage./(ones(size(BasicImage,1),1)*SumofColumns); % Equal the sum of all image columns
VerifyFlag=max(abs(sum(ElaboratedImage,1)/(size(BasicImage,2))-1))<1e-3;

function [ElaboratedImage,VerifyFlag]=AverageOnRows(BasicImage)
SumofRows=sum(BasicImage,2)/size(BasicImage,2);
ElaboratedImage=BasicImage./(SumofRows*ones(1,size(BasicImage,2))); % Equal the sum of all image columns
VerifyFlag=max(abs(sum(ElaboratedImage,2)/(size(BasicImage,1))-1))<1e-3;

function statistics=FindStatistics(Image)
if isempty(Image)
    statistics=[];
    return
end
statistics(1)=mean(Image(:));
statistics(2)=std(Image(:));
statistics(3)=statistics(2)/statistics(1);

function []=PlotResults(BasicImage,ElaboratedImage1,ElaboratedImage2,ElaboratedImage3)
subplot(2,2,1)
imagesc(BasicImage); colormap('gray')
title('Basic Image')
subplot(2,2,2)
imagesc(ElaboratedImage1); colormap('gray')
title('Proposed Algorithm on Columns')
subplot(2,2,3)
imagesc(ElaboratedImage2); colormap('gray')
title('Proposed Algorithm on Rows')
subplot(2,2,4)
imagesc(ElaboratedImage3); colormap('gray')
title('Proposed Algorithm on Columns and Then Rows')

function NewImage=RemoveMargins(OldImage,RowsMargin,ColumnsMargin)
NewImage=OldImage;
NewImage(1:RowsMargin,:)=[];
NewImage(end-RowsMargin:end,:)=[];
NewImage(:,1:ColumnsMargin)=[];
NewImage(:,end-ColumnsMargin:end)=[];




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
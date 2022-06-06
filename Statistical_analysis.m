clc;
clear all;
close all;
num=xlsread('C:\Users\lmz\Desktop\Fiber coordinate.xls');
%% 
length=0.165;
width=0.165;
radius=0.0033;
column_number=size(num,2);
wholemin_Z=[];
wholemin_Z2=[];
wholemin_Z3=[];
wholejiaodu=[];
wholejiaodu2=[];
wholejiaodu3=[];
for d=1:column_number/2 
    distmat = pdist(num(:,2*d-1:2*d));
    Z = squareform(distmat);
    Z=Z/radius;
    Z(Z==0)=NaN;
    [min_Z,index]=min(Z,[],2);
    wholemin_Z = [wholemin_Z;min_Z];
    Z2 = Z;
    for i=1:size(num(:,2*d-1:2*d),1)
        Z2(i,index(i))=NaN;
    end
    [min_Z2,index2]=min(Z2,[],2);
    wholemin_Z2=[wholemin_Z2;min_Z2];
    Z3 = Z2;
    for i=1:size(num(:,2*d-1:2*d),1)
        Z3(i,index2(i))=NaN;
    end
    [min_Z3,index3]=min(Z3,[],2);
    wholemin_Z3=[wholemin_Z3;min_Z3];
    detax_temp=0.025;
    x_temp = 1.8:detax_temp:2.8;
    [a_temp(d,:),xout_temp] = hist(min_Z,x_temp);
    [b_temp(d,:),xout2_temp] = hist(min_Z2,x_temp);
    [b2_temp(d,:),xout22_temp] = hist(min_Z3,x_temp);
    summ_temp=sum(a_temp(d,:));
    summ2_temp=sum(b_temp(d,:));
    summ22_temp=sum(b2_temp(d,:));
    a_temp(d,:)=a_temp(d,:)/summ_temp/detax_temp/3.3;
    b_temp(d,:)=b_temp(d,:)/summ2_temp/detax_temp/3.3;
    b2_temp(d,:)=b2_temp(d,:)/summ22_temp/detax_temp/3.3;
            
    Z(isnan(Z)==1)=0;
    %% 
    jiaodu = [];
    for j=1:size(num(:,2*d-1:2*d),1)
        x1=num(j,2*d-1);
        y1=num(j,2*d);
        x2=num(index(j),2*d-1);
        y2=num(index(j),2*d);
        cosjiaodu = (x2-x1)/sqrt((x2-x1)^2+(y2-y1)^2);
        if (y2-y1>=0)
             hudujiaodu(j) = acos(cosjiaodu);
             jiaodu(j) = hudujiaodu(j)*180/pi;
        else
             hudujiaodu(j) = -acos(cosjiaodu);
             jiaodu(j) = hudujiaodu(j)*180/pi;
        end
    end
    for j=1:size(num(:,2*d-1:2*d),1)
        x1=num(j,2*d-1);
        y1=num(j,2*d);
        x2=num(index2(j),2*d-1);
        y2=num(index2(j),2*d);
        cosjiaodu2 = (x2-x1)/sqrt((x2-x1)^2+(y2-y1)^2);
        if (y2-y1>=0)
             hudujiaodu2(j) = acos(cosjiaodu2);
             jiaodu2(j) = hudujiaodu2(j)*180/pi;
        else
             hudujiaodu2(j) = -acos(cosjiaodu2);
             jiaodu2(j) = hudujiaodu2(j)*180/pi;
        end
    end
    for j=1:size(num(:,2*d-1:2*d),1)
        x1=num(j,2*d-1);
        y1=num(j,2*d);
        x2=num(index3(j),2*d-1);
        y2=num(index3(j),2*d);
        cosjiaodu3 = (x2-x1)/sqrt((x2-x1)^2+(y2-y1)^2);
        if (y2-y1>=0)
             hudujiaodu3(j) = acos(cosjiaodu3);
             jiaodu3(j) = hudujiaodu3(j)*180/pi;
        else
             hudujiaodu3(j) = -acos(cosjiaodu3);
             jiaodu3(j) = hudujiaodu3(j)*180/pi;
        end
    end
    wholejiaodu=[wholejiaodu;hudujiaodu];
    wholejiaodu2=[wholejiaodu2;hudujiaodu2];
    wholejiaodu3=[wholejiaodu3;hudujiaodu3];
    jiaodu_temp=wholejiaodu;
    jiaodu2_temp=wholejiaodu2;
    jiaodu3_temp=wholejiaodu3;
    detax2_temp=20/360*pi;
    x2_temp=[-pi:detax2_temp:pi];
    [c_temp(d,:),xout3_temp] = hist(jiaodu_temp(d,:),x2_temp);
    [c2_temp(d,:),xout32_temp] = hist(jiaodu2_temp(d,:),x2_temp);
    [c3_temp(d,:),xout33_temp] = hist(jiaodu3_temp(d,:),x2_temp);
    summ3_temp = sum(c_temp(d,:));
    c_temp(d,:)=c_temp(d,:)/summ3_temp/detax2_temp;
    c2_temp(d,:)=c2_temp(d,:)/summ3_temp/detax2_temp;
    c3_temp(d,:)=c3_temp(d,:)/summ3_temp/detax2_temp;
    
    %%
    num_internal=num(:,2*d-1:2*d);
    row_number = size(num_internal,1);
    for i=1:row_number;
        if (num_internal(i,1)<0)||(num_internal(i,1)>width)||(num_internal(i,2)<0)||(num_internal(i,2)>length)
            num_internal(i,:)=[inf,inf];
        end
    end
    for i=row_number:-1:1;
        if num_internal(i,:)==[inf,inf]
            num_internal(i,:)=[];
        end
    end
    A=length*width;
    N=size(num_internal,1);
    detah=0.000825;
    for h=detah:detah:(15*radius)
        for i=1:N
            hx=num_internal(i,1);
            hy=num_internal(i,2);
            hnum(i)=0;
            for j=1:size(num_internal,1)
                dij=((num_internal(j,1)-hx)^2+(num_internal(j,2)-hy)^2)^0.5;
                if (dij<h)&&(i~=j)
                    w(j)=1;
                    I=1;
                    if(hx<dij)&&((hy-dij)*(width-dij-hy)>0)
                        jiaodu2=acos(hx/dij)/2/pi*360;
                        w(j)=(360-2*jiaodu2)/360;
                    elseif(hx>length-dij)&&((hy-dij)*(width-dij-hy)>0)
                        jiaodu2=acos((width-hx)/dij)/2/pi*360;
                        w(j)=(360-2*jiaodu2)/360;  
                    elseif(hy<dij)&&((hx-dij)*(length-dij-hx)>0)
                        jiaodu2=acos(hy/dij)/2/pi*360;
                        w(j)=(360-2*jiaodu2)/360;  
                    elseif(hy>width-dij)&&((hx-dij)*(length-dij-hx)>0)
                        jiaodu2=acos((length-hy)/dij)/2/pi*360;
                        w(j)=(360-2*jiaodu2)/360;            
                    elseif(hx<dij)&&(hy<dij)
                        jiaodu2=(acos(hx/dij)+acos(hy/dij))/2/pi*360+90;
                        w(j)=(360-jiaodu2)/360;        
                    elseif(hx<dij)&&(hy>(width-dij))
                        jiaodu2=(acos(hx/dij)+acos((length-hy)/dij))/2/pi*360+90;
                        w(j)=(360-jiaodu2)/360;          
                    elseif(hx>(length-dij))&&(hy<dij)      
                        jiaodu2=(acos((width-hx)/dij)+acos(hy/dij))/2/pi*360+90;
                        w(j)=(360-jiaodu2)/360;          
                    elseif(hx>(length-dij))&&(hy>(width-dij))              
                        jiaodu2=(acos((width-hx)/dij)+acos((width-hy)/dij))/2/pi*360+90;
                        w(j)=(360-jiaodu2)/360;  
                    end 
                    hnum(i)=hnum(i)+I/w(j);
                else
                    I=0;
                end
            end
        end
        cigema=sum(hnum)*1000*1000;
        khcat(int32(h/detah),1)=[h/radius];
        khcat(int32(h/detah),d+1)=[A/N/N*cigema];        
    end
    
    %% 
    khcat2=khcat.';
    ghx=khcat2(1,:);
    ghx=khcat2(1,:)*radius*1000;
    ghy=khcat2(d+1,:);
    dkr=diff(ghy);
    dr=diff(ghx);
    dx=30/size(khcat2,2):15/size(khcat2,2):15;
    r=30/size(khcat2,2)*radius*1000:15/size(khcat2,2)*radius*1000:15*radius*1000;
    dy=dkr./dr;
    gr(d,:)=dy./r/2/pi;
end

%% 
detax=0.025;
x = 1.8:detax:2.8;
xp = 1.8:detax:2.8+detax;
[a,xout] = hist(wholemin_Z,xp);
[b,xout2] = hist(wholemin_Z2,xp);
a(:,42)=[];
xout(:,42)=[];
b(:,42)=[];
xout2(:,42)=[];
summ = sum(a);
summ2 = sum(b);
a=a/summ/detax/3.3;
b=b/summ2/detax/3.3;
totalprobablity=sum(a)*detax*3.3;
totalprobablity2=sum(b)*detax*3.3;

[max_a_temp,index_a_temp]=max(a_temp,[],1);
[min_a_temp,index2_a_temp]=min(a_temp,[],1);
[max_b_temp,index_b_temp]=max(b_temp,[],1);
[min_b_temp,index2_b_temp]=min(b_temp,[],1);
max_a_temp=max_a_temp-a;
min_a_temp=a-min_a_temp;
max_b_temp=max_b_temp-b;
min_b_temp=b-min_b_temp;

detax2=detax2_temp;
x2=x2_temp;
wholejiaodu=wholejiaodu(:);
wholejiaodu2=wholejiaodu2(:);
wholejiaodu3=wholejiaodu3(:);
[c,xout3] = hist(wholejiaodu,x2);
[c2,xout32] = hist(wholejiaodu2,x2);
[c3,xout33] = hist(wholejiaodu3,x2);
summ3 = sum(c);
c(:,1)=c(:,1)+c(:,2*pi/detax2+1);
c(:,2*pi/detax2+1)=c(:,1);
c2(:,1)=c2(:,1)+c2(:,2*pi/detax2+1);
c2(:,2*pi/detax2+1)=c2(:,1);
c3(:,1)=c3(:,1)+c3(:,2*pi/detax2+1);
c3(:,2*pi/detax2+1)=c3(:,1);
    
c=c/summ3/detax2;
c2=c2/summ3/detax2;
c3=c3/summ3/detax2;
totalprobablity3=sum(c)*detax2;

c_temp(:,1)=c_temp(:,1)+c_temp(:,2*pi/detax2+1);
c_temp(:,2*pi/detax2+1)=c_temp(:,1);
c2_temp(:,1)=c2_temp(:,1)+c2_temp(:,2*pi/detax2+1);
c2_temp(:,2*pi/detax2+1)=c2_temp(:,1);
c3_temp(:,1)=c3_temp(:,1)+c3_temp(:,2*pi/detax2+1);
c3_temp(:,2*pi/detax2+1)=c3_temp(:,1);

[max_c_temp,index_c_temp]=max(c_temp,[],1);
[min_c_temp,index2_c_temp]=min(c_temp,[],1);
max_c_temp=max_c_temp-c;
min_c_temp=c-min_c_temp;

[max_c2_temp,index_c2_temp]=max(c2_temp,[],1);
[min_c2_temp,index2_c2_temp]=min(c2_temp,[],1);
max_c2_temp=max_c2_temp-c2;
min_c2_temp=c2-min_c2_temp;

[max_c3_temp,index_c3_temp]=max(c3_temp,[],1);
[min_c3_temp,index2_c3_temp]=min(c3_temp,[],1);
max_c3_temp=max_c3_temp-c3;
min_c3_temp=c3-min_c3_temp;

wholekhcat(:,1)= khcat(:,1);
wholekhcat(:,2)=mean(khcat(:,2:(size(khcat,2))),2);

wholegr(1,:)=mean(gr(1:(size(gr,1)),:),1);

[max_gr_temp,index_gr_temp]=max(gr,[],1);
[min_gr_temp,index2_gr_temp]=min(gr,[],1);
max_gr_temp=max_gr_temp-wholegr;
min_gr_temp=wholegr-min_gr_temp;

experimentx1=[1.81724
1.87931
1.93793
2.00192
2.0613
2.12184
2.18276
2.24444
2.3046
2.36513
2.42452
2.48621
2.54636
2.6069
2.6682
2.72759];
experimenty1=[0
0
0.01613
0.10394
0.55914
1.44803
1.5
0.73477
0.33333
0.12366
0.08065
0.03226
0.0233
0.01792
0.00896
0.01613];
experimentx2=[1.81916
1.87931
1.94023
2.00077
2.06015
2.12146
2.18314
2.24406
2.30498
2.36552
2.42414
2.48544
2.54598
2.6069
2.6682
2.7272
];
experimenty2=[0
0
0.02389
0.1147
0.56511
1.44683
1.4994
0.73716
0.32497
0.11828
0.07527
0.03704
0.02031
0.02151
0.00836
0.01075
];
experimentx3=[-3.14159
-2.96207
-2.78255
-2.60303
-2.42351
-2.24399
-2.06448
-1.88496
-1.70544
-1.52592
-1.3464
-1.16688
-0.98736
-0.80784
-0.62832
-0.4488
-0.26928
-0.08976
0.08976
0.26928
0.4488
0.62832
0.80784
0.98736
1.16688
1.3464
1.52592
1.70544
1.88496
2.06448
2.24399
2.42351
2.60303
2.78255
2.96207
3.14159
];
experimenty3=[0.0731
0.09847
0.09669
0.11818
0.14177
0.16051
0.20155
0.23935
0.23831
0.22862
0.24647
0.23452
0.18032
0.16077
0.12548
0.1153
0.09648
0.07653
0.1124
0.09722
0.10328
0.13462
0.1381
0.16572
0.22501
0.22268
0.24223
0.25838
0.23334
0.1911
0.17931
0.1403
0.10912
0.09232
0.09838
0.07326
];
experimentx4=[-3.14159
-2.96207
-2.78255
-2.60303
-2.42351
-2.24399
-2.06448
-1.88496
-1.70544
-1.52592
-1.3464
-1.16688
-0.98736
-0.80784
-0.62832
-0.4488
-0.26928
-0.08976
0.08976
0.26928
0.4488
0.62832
0.80784
0.98736
1.16688
1.3464
1.52592
1.70544
1.88496
2.06448
2.24399
2.42351
2.60303
2.78255
2.96207
3.14159
];
experimenty4=[0.15638
0.14444
0.13189
0.14095
0.15165
0.1786
0.17983
0.15309
0.1679
0.18971
0.16852
0.17593
0.18333
0.16111
0.1537
0.13519
0.13889
0.13889
0.14259
0.13704
0.16296
0.1537
0.16296
0.16481
0.17963
0.17407
0.17593
0.16852
0.18704
0.17037
0.18518
0.18333
0.12963
0.12222
0.13333
0.15741
];experimentx5=[-3.14159
-2.96207
-2.78255
-2.60303
-2.42351
-2.24399
-2.06448
-1.88496
-1.70544
-1.52592
-1.3464
-1.16688
-0.98736
-0.80784
-0.62832
-0.4488
-0.26928
-0.08976
0.08976
0.26928
0.4488
0.62832
0.80784
0.98736
1.16688
1.3464
1.52592
1.70544
1.88496
2.06448
2.24399
2.42351
2.60303
2.78255
2.96207
3.14159
];
experimenty5=[0.21666
0.18888
0.1759
0.18515
0.13699
0.13883
0.124
0.11473
0.12954
0.13323
0.11099
0.14987
0.14986
0.17577
0.15909
0.14427
0.19426
0.20165
0.22942
0.20163
0.17939
0.16827
0.16085
0.13862
0.14046
0.12748
0.12007
0.1145
0.13115
0.15707
0.16261
0.15704
0.16444
0.19591
0.2033
0.21626
];
figure(column_number/2+1);

errorbar(x,a,min_a_temp,max_a_temp,'b-o','MarkerFaceColor','b');
xlabel('H/r');
ylabel('Probablity Density');
set(gca,'XLim',[1.8 2.8]);
set(gca,'YLim',[0 3]);
grid on
hold on
plot(experimentx1,experimenty1,'-ro','linewidth',2,'MarkerFaceColor','g')

figure(column_number/2+2);
errorbar(x,b,min_b_temp,max_b_temp,'b-s','MarkerFaceColor','b');
xlabel('H/r');
ylabel('Probablity Density');
set(gca,'XLim',[1.8 2.8]);
set(gca,'YLim',[0 2]);
grid on
hold on
plot(experimentx2,experimenty2,'-ro','linewidth',2,'MarkerFaceColor','g')
figure(column_number/2+3);
errorbar(x2,c,min_c_temp,max_c_temp,'b-o','MarkerFaceColor','b');
xlabel('Orientation');
ylabel('Probablity Density');
set(gca,'XLim',[-pi pi]);
set(gca,'YLim',[0 0.4]);
grid on
hold on
plot(experimentx3,experimenty3,'-ro','linewidth',2,'MarkerFaceColor','g')
figure(column_number/2+4);
errorbar(x2,c2,min_c2_temp,max_c2_temp,'b-o','MarkerFaceColor','b');
xlabel('Orientation');
ylabel('Probablity Density');
set(gca,'XLim',[-pi pi]);
set(gca,'YLim',[0 0.4]);
grid on
hold on
plot(experimentx4,experimenty4,'-ro','linewidth',2,'MarkerFaceColor','g')
figure(column_number/2+5);
errorbar(x2,c3,min_c3_temp,max_c3_temp,'b-o','MarkerFaceColor','b');
xlabel('Orientation');
ylabel('Probablity Density');
set(gca,'XLim',[-pi pi]);
set(gca,'YLim',[0 0.4]);
grid on
hold on
plot(experimentx5,experimenty5,'-ro','linewidth',2,'MarkerFaceColor','g')
figure(column_number/2+6)
plot(wholekhcat(:,1),wholekhcat(:,2),'-r','linewidth',1)
hold on
csrx=0:0.001:15;
csry=pi*power(csrx*radius*1000,2);
plot(csrx,csry,'--b','linewidth',1)

figure(column_number/2+7)
errorbar(dx,wholegr,min_gr_temp,max_gr_temp,'b-');
hold on
csrx2=0:0.001:15;
csry2=csrx2*0+1;
plot(csrx2,csry2,'--k','linewidth',1)
set(gca,'XLim',[0 15]);
set(gca,'YLim',[0 6]);

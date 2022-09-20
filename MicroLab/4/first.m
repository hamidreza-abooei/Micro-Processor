clc
clear
close all
%%
s=serial('COM8', 'BaudRate', 9600, 'Parity', 'none','DataBits',8,'StopBits', 1);
set(s, 'InputBufferSize', 1024);
set(s, 'Timeout',10);
s.terminator = 'LF';
fopen(s);
disp('Recording...');
A=0;t=1;
while(t<1024)
    a =fread(s,1);
    plot(t,a,'--rs','LineWidth',2,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','g',...
    'MarkerSize',5);
    xlabel('Sample No','FontWeight','bold','FontSize',14,'Color', ...
    [1 0 0]);
    ylabel('Temperature','FontWeight','bold','FontSize',14,'Color',...
    [1 0 0]);
    title('Communication of MATLAB and LPC1768 through UART' , ...
    'FontSize',15,'Color',[1 0 0]);
    grid on;
    hold on;
    t=t+1;
    drawnow;
end
fclose(s);
delete(s);
clear s;
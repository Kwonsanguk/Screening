function varargout = screening_gui(varargin)
% SCREENING_GUI MATLAB code for screening_gui.fig
%      SCREENING_GUI, by itself, creates a new SCREENING_GUI or raises the existing
%      singleton*.
%
%      H = SCREENING_GUI returns the handle to a new SCREENING_GUI or the handle to
%      the existing singleton*.
%
%      SCREENING_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCREENING_GUI.M with the given input arguments.
%
%      SCREENING_GUI('Property','Value',...) creates a new SCREENING_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before screening_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to screening_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help screening_gui

% Last Modified by GUIDE v2.5 25-May-2020 22:07:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @screening_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @screening_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before screening_gui is made visible.
function screening_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to screening_gui (see VARARGIN)

% Choose default command line output for screening_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes screening_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = screening_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename ,path] = uigetfile({'*.xlsx; *.xls','Exel Files(*.xlsx,*.xls)'},'Select file name');
openfile = fullfile(path,filename);
hExcel = actxserver('excel.application'); 
hExcel.Workbooks.Open(openfile);
Rawdata = hExcel.Worksheets.Item('Sheet1').UsedRange.Value;
Rawdata = cell2mat(Rawdata);
hExcel.Quit;
delete(hExcel)
handles.Filename = filename;
handles.Rawdata = Rawdata;
guidata(hObject,handles);
edit3_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on key press with focus on pushbutton1 and none of its controls.
function pushbutton1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
a = handles.Rawdata;

cell_number = zeros(length(a),1);

for i = 1: length(a)
    cell_number(i) = i;
end

parameter1 = a(:,1);
parameter2 = a(:,2);
lg_parameter = length(parameter1);

average_parameter1 = mean(parameter1);
std_parameter1 = std(parameter1);
average_parameter2 = mean(parameter2);
std_parameter2 = std(parameter2);

% Standarlization for each parameter
stan_parameter1 = zeros(lg_parameter,1);
stan_parameter2 = zeros(lg_parameter,1);
for j = 1: lg_parameter
    stan_parameter1(j) = (parameter1(j) - average_parameter1) / std_parameter1; 
end

for j = 1: lg_parameter
    stan_parameter2(j) = (parameter2(j) - average_parameter2) / std_parameter2; 
end
stan_parameter = [stan_parameter1, stan_parameter2];
axes(handles.axes2);
plot(stan_parameter1,stan_parameter2,'.','MarkerSize',20);
grid on;
title('Stadarlization','fontsize',12,'fontname','arial');

 handles.cell_number = cell_number;
 handles.stan_parameter = stan_parameter;
 guidata(hObject,handles);
 handles.lg_parameter = lg_parameter;
guidata(hObject,handles);





% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Number of Outlier'};
title = 'Value';
dims = [1 25];
definput = {''};
answer = inputdlg(prompt,title,dims,definput);
answer = cell2mat(answer);
ans = str2num(answer);

Rowdata = handles.stan_parameter;
lg_cell_number =  handles.lg_parameter;
user_input = ans;
cell_number = zeros(lg_cell_number,1);

for i = 1: lg_cell_number
    cell_number(i) = i;
end
normal_parameter1 = Rowdata(:,1);
normal_parameter2 = Rowdata(:,2);

cell_data = [cell_number, Rowdata];
[idx,C] = kmeans(Rowdata,1);

distance_data = zeros(lg_cell_number,1);
for i = 1 : lg_cell_number
    distance_data(i) = sqrt((C(1,1) - normal_parameter1(i))^2 + (C(1,2) - normal_parameter2(i))^2);
end

cell_data2 = [cell_number,Rowdata,distance_data];
[A, Indexing_A] = sort(cell_data2,'descend');
Outlier_cell_track = Indexing_A(:,4);
Outlier_cell_number = Outlier_cell_track(1: ans);

cell_data_real = [];

for i = 1 : lg_cell_number
if cell_data2(i,1) ~= Outlier_cell_number
   cell_data_real = [cell_data_real;cell_data2(i,:)];
end
end

axes(handles.axes2);
  plot(cell_data_real(:,2),cell_data_real(:,3),'.','MarkerSize',20);
  grid on;
%   title('Stadarlization','fontsize',12,'fontname','arial');

handles.stan_parameter = cell_data_real(:,2:3);
handles.Outlier_cell_number = Outlier_cell_number;
handles.cell_number = cell_data_real(:,1);
handles.lg_parameter = length(cell_data_real);
guidata(hObject,handles);

edit1_Callback(hObject, eventdata, handles);




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
 Outlier_cell_number_str = num2str(handles.Outlier_cell_number);
 cull_number_total = [];
for i = 1: length(handles.Outlier_cell_number)
    cell_number = sprintf('%s  ',Outlier_cell_number_str(i,:));
    cull_number_total=[cull_number_total;cell_number];
end
set(handles.edit1,'String',sprintf('Outlier cell number : %s',cull_number_total'));
% Outlier_text
% handles.Outlier_cell_number


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 filenum = 'Number of Entire data \n %d\n\nNumber of Screening data';    
 num = handles.lg_parameter;
 filename1=sprintf(filenum,num);
 prompt = {filename1};
 title = 'Value';
 dims = [1 25];
 answer = inputdlg(prompt,title,dims);
 
ans_ = str2double(answer);
ans1 = handles.lg_parameter;
ans2 = ans_;
group = ans1/ans2;
answer_group = floor(group)-1;  % 마진을 위해 계산값에서 -1
if answer_group <= 10
    handles.answer_group = answer_group;
    guidata(hObject,handles);
    edit2_Callback(hObject, eventdata, handles)
else
    uiwait(msgbox('Cannot exceed 10','Success','modal'));
end
    




function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit2,'String',sprintf('Optimal Group : %d',handles.answer_group));

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = handles.stan_parameter;
b = handles.cell_number;
xp=[a(:,1),a(:,2)];
x= [a'];
lg = handles.lg_parameter;
y=zeros(1,lg);
k= handles.answer_group;
n=round(91*rand(1,k)+1);
center=x(:,n);

y2 = zeros(lg,1);

for i = 1:lg
    for j = 1:lg
        temp_min=1000000;
        temp_knum=0;
        
        for ii=1:k

            temp=norm(x(:,j)- center(:,ii));
         
            if(temp<temp_min)
                temp_min = temp;
                temp_knum = ii;
            end
        end
        y(j)= temp_knum;
    end
        for j=1:k
        x_temp=[];
        for ii=1:lg
            if(y(ii)==j)
                x_temp=[x_temp x(:,ii)];
            end
        end
                    new_center=mean(x_temp,2);
                    center(1,j)=new_center(1);
                    center(2,j)=new_center(2);
        end
                
         temp_sum = 0;
    for i=1:lg
        for j=1:k            
            temp(j) = norm(x(:,i)-center(:,j));
        end
        temp_sum = temp_sum + min(temp);
        
    end
 
end

handles.k = k;
handles.lg = lg;
handles.x = x;
handles.celldata = [x;b'];
handles.y = y;
handles.center = center;
guidata(hObject,handles);

celldata = handles.celldata;
   
for i=1:lg
    if(y(i) == 1)
        plot(celldata(1,i),celldata(2,i),'b.');
        xlabel('Capacity factor');
        ylabel('Voltage factor');
        hold on;
    elseif(y(i) == 2)
        plot(celldata(1,i),celldata(2,i),'g.');
        xlabel('Capacity factor');
        ylabel('Voltage factor'); 
    elseif(y(i) == 3)
        plot(celldata(1,i),celldata(2,i),'r.');
        xlabel('Capacity factor');
        ylabel('Voltage factor');
    elseif(y(i) == 4)
        plot(celldata(1,i),celldata(2,i),'k.'); 
        xlabel('Capacity factor');
        ylabel('Voltage factor');
    elseif(y(i) == 5)
        plot(celldata(1,i),celldata(2,i),'m.'); 
        xlabel('Capacity factor');
        ylabel('Voltage factor');
    elseif(y(i) == 6)
        plot(celldata(1,i),celldata(2,i),'c.');
        xlabel('Capacity factor');
        ylabel('Voltage factor');
    elseif(y(i) == 7)
        plot(celldata(1,i),celldata(2,i),'y.');
        xlabel('Capacity factor');
        ylabel('Voltage factor');
    elseif(y(i) == 8)
        plot(celldata(1,i),celldata(2,i),'ro');
        xlabel('Capacity factor');
        ylabel('Voltage factor');
    elseif(y(i) == 9)
        plot(celldata(1,i),celldata(2,i),'bo');
        xlabel('Capacity factor');
        ylabel('Voltage factor');
        hold on;
    elseif(y(i) == 10)
        plot(celldata(1,i),celldata(2,i),'go');
        xlabel('Capacity factor');
        ylabel('Voltage factor');         
    end
end

edit4_Callback(hObject, eventdata, handles)




% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes2if(k==1)

    



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit3,'String',sprintf('%s',handles.Filename));
% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

k = handles.k;
lg = handles.lg ;
celldata = handles.celldata ;
y = handles.y ;

    count = [1,1,1,1,1,1,1,1,1,1];   % 군집 개수 10개
    
for ii = 1 : k     
for i=1:lg
   if y(i) == ii && ii == 1
       cluster_mat1(count(ii),1) = celldata(1,i);
       cluster_mat1(count(ii),2) = celldata(2,i);
       cluster_mat1(count(ii),3) = celldata(3,i);
       count(ii) = count(ii) +1;
   end
   if y(i) == ii && ii == 2
       cluster_mat2(count(ii),1) = celldata(1,i);
       cluster_mat2(count(ii),2) = celldata(2,i);
       cluster_mat2(count(ii),3) = celldata(3,i);
       count(ii) = count(ii) +1;
   end
   if y(i) == ii && ii == 3
       cluster_mat3(count(ii),1) = celldata(1,i);
       cluster_mat3(count(ii),2) = celldata(2,i);
       cluster_mat3(count(ii),3) = celldata(3,i);
       count(ii) = count(ii) +1;
   end
   if y(i) == ii && ii == 4
       cluster_mat4(count(ii),1) = celldata(1,i);
       cluster_mat4(count(ii),2) = celldata(2,i);
       cluster_mat4(count(ii),3) = celldata(3,i);
       count(ii) = count(ii) +1;
   end
   if y(i) == ii && ii == 5
       cluster_mat5(count(ii),1) = celldata(1,i);
       cluster_mat5(count(ii),2) = celldata(2,i);
       cluster_mat5(count(ii),3) = celldata(3,i);
       count(ii) = count(ii) +1;
   end
   if y(i) == ii && ii == 6
       cluster_mat6(count(ii),1) = celldata(1,i);
       cluster_mat6(count(ii),2) = celldata(2,i);
       cluster_mat6(count(ii),3) = celldata(3,i);
       count(ii) = count(ii) +1;
   end
   if y(i) == ii && ii == 7
       cluster_mat7(count(ii),1) = celldata(1,i);
       cluster_mat7(count(ii),2) = celldata(2,i);
       cluster_mat7(count(ii),3) = celldata(3,i);
       count(ii) = count(ii) +1;
   end
   if y(i) == ii && ii == 8
       cluster_mat8(count(ii),1) = celldata(1,i);
       cluster_mat8(count(ii),2) = celldata(2,i);
       cluster_mat8(count(ii),3) = celldata(3,i);
       count(ii) = count(ii) +1;
   end
   if y(i) == ii && ii == 9
       cluster_mat9(count(ii),1) = celldata(1,i);
       cluster_mat9(count(ii),2) = celldata(2,i);
       cluster_mat9(count(ii),3) = celldata(3,i);
       count(ii) = count(ii) +1;
   end
   if y(i) == ii && ii == 10
       cluster_mat10(count(ii),1) = celldata(1,i);
       cluster_mat10(count(ii),2) = celldata(2,i);
       cluster_mat10(count(ii),3) = celldata(3,i);
       count(ii) = count(ii) +1;
   end
end           
end

if exist('cluster_mat1') == 1
    std_mat(1,:) = std(cluster_mat1(:,1:2));
end
if exist('cluster_mat2') == 1
    std_mat(2,:) = std(cluster_mat2(:,1:2));
end
if exist('cluster_mat3') == 1
    std_mat(3,:) = std(cluster_mat3(:,1:2));
end
if exist('cluster_mat4') == 1
    std_mat(4,:) = std(cluster_mat4(:,1:2));
end
if exist('cluster_mat5') == 1
    std_mat(5,:) = std(cluster_mat5(:,1:2));
end
if exist('cluster_mat6') == 1
    std_mat(6,:) = std(cluster_mat6(:,1:2));
end
if exist('cluster_mat7') == 1
    std_mat(7,:) = std(cluster_mat7(:,1:2));
end
if exist('cluster_mat8') == 1
    std_mat(8,:) = std(cluster_mat8(:,1:2));
end
if exist('cluster_mat9') == 1
    std_mat(9,:) = std(cluster_mat9(:,1:2));
end
if exist('cluster_mat10') == 1
    std_mat(10,:) = std(cluster_mat10(:,1:2));
end

for i = 1 : length(std_mat)
    std_mat_mean(i) = mean(std_mat(i,1:2));
end

cluster_std_min = find(std_mat_mean==min(std_mat_mean));
[cluster_std_sort,cluster_Index] = sort(std_mat_mean);

handles.cluster_std_min = cluster_std_min;
handles.std_mat_mean = std_mat_mean;
handles.cluster_std_sort = cluster_std_sort;
handles.cluster_Index = cluster_Index;

if exist('cluster_mat1') == 1
    handles.cluster_mat1 = cluster_mat1;
    handles.cell_numbers = length(cluster_mat1);
    Cluster_data.cluster_mat1 = cluster_mat1;
end
if exist('cluster_mat2') == 1
    handles.cluster_mat2 = cluster_mat2;
    handles.cell_numbers = [handles.cell_numbers,length(cluster_mat2)];
    Cluster_data.cluster_mat2 = cluster_mat2;
end
if exist('cluster_mat3') == 1
    handles.cluster_mat3 = cluster_mat3;
    handles.cell_numbers = [handles.cell_numbers,length(cluster_mat2)];
    Cluster_data.cluster_mat3 = cluster_mat3;
end
if exist('cluster_mat4') == 1
    handles.cluster_mat4 = cluster_mat4;
    handles.cell_numbers = [handles.cell_numbers,length(cluster_mat3)];
    Cluster_data.cluster_mat4 = cluster_mat4;
end
if exist('cluster_mat5') == 1
    handles.cluster_mat5 = cluster_mat5;
    handles.cell_numbers = [handles.cell_numbers,length(cluster_mat4)];
    Cluster_data.cluster_mat5 = cluster_mat5;
end
if exist('cluster_mat6') == 1
    handles.cluster_mat6 = cluster_mat6;
    handles.cell_numbers = [handles.cell_numbers,length(cluster_mat5)];
    Cluster_data.cluster_mat6 = cluster_mat6;
end
if exist('cluster_mat7') == 1
    handles.cluster_mat7 = cluster_mat7;
    handles.cell_numbers = [handles.cell_numbers,length(cluster_mat6)];
    Cluster_data.cluster_mat7 = cluster_mat7;
end
if exist('cluster_mat8') == 1
    handles.cluster_mat8 = cluster_mat8;
    handles.cell_numbers = [handles.cell_numbers,length(cluster_mat7)];
    Cluster_data.cluster_mat8 = cluster_mat8;
end
if exist('cluster_mat9') == 1
    handles.cluster_mat9 = cluster_mat9;
    handles.cell_numbers = [handles.cell_numbers,length(cluster_mat8)];
    Cluster_data.cluster_mat9 = cluster_mat9;
end
if exist('cluster_mat10') == 1
    handles.cluster_mat10 = cluster_mat10;
    handles.cell_numbers = [handles.cell_numbers,length(cluster_mat9)];
    Cluster_data.cluster_mat10 = cluster_mat10;
end
     
guidata(hObject,handles);

set(handles.edit4,'String',sprintf('Selected Group : %d',cluster_std_min));
set(handles.edit10,'String',num2str(handles.cell_numbers));

axes(handles.axes3);
bar(std_mat_mean)
xlabel('Group number');
ylabel('standard deviation');

save_mat = strcat('Screening_par','.mat');
save(save_mat,'Cluster_data')
assignin('base','handles',handles);
assignin('base','Cluster_data',Cluster_data);

uiwait(msgbox('Operation Completed','Success','modal'));


% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes2if(k==1)


% --- Executes during object creation, after setting all properties.
function pushbutton2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function pushbutton3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox1



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Save_filename = handles.edit8.String;
cluster_std_min = handles.cluster_std_min;

if cluster_std_min == 1
   xlswrite(Save_filename,handles.cluster_mat1(:,3))
end
if cluster_std_min == 2
   xlswrite(Save_filename,handles.cluster_mat2(:,3))
end
if cluster_std_min == 3
   xlswrite(Save_filename,handles.cluster_mat3(:,3))
end
if cluster_std_min == 4
   xlswrite(Save_filename,handles.cluster_mat4(:,3))
end
if cluster_std_min == 5
   xlswrite(Save_filename,handles.cluster_mat5(:,3))
end
if cluster_std_min == 6
   xlswrite(Save_filename,handles.cluster_mat6(:,3))
end
if cluster_std_min == 7
   xlswrite(Save_filename,handles.cluster_mat7(:,3))
end
if cluster_std_min == 8
   xlswrite(Save_filename,handles.cluster_mat8(:,3))
end
if cluster_std_min == 9
   xlswrite(Save_filename,handles.cluster_mat9(:,3))
end
if cluster_std_min == 10
   xlswrite(Save_filename,handles.cluster_mat10(:,3))
end
uiwait(msgbox('Operation Completed','Success','modal'));


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Hi')



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

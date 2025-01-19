function [freeman_code, X0, curvature] = discrete_curvature(I, radius, option_display)
%% discrete_curvature : function to compute and display the discrete
% curvature vector of the given binary image I
%
%%% Author : nicolas.douillet9 (at) gmail.com, 2005-2025.
%
%
%%% Inputs arguments
%
% - I : either logical (true/false | 1/0) or numeric (255/0) matrix. Binary image. Size(I,3) = 1. Mandatory.
%
% - radius : positive integer scalar double, the choosen curvature radius. radius > 1 and radius = 2 by default. Optional.
%
% - option_display : logical (true/false | 1/0). Optional.
%
%
%%% Output arguments
%
% - freeman_code : integer row vector double, the Freeman chain code of the image/shape contour.
%
% - X0 : positive integer column vector double, the Freeman starting pixel coordinates. size(X0) = [1,2].
%
% - curvature : integer row vector double, the curvature code of the image/shape contour. Size(curvature) = [1,length(freeman_code)].


%% Input parsing
if nargin < 3
   
    option_display = true;
    
    if nargin < 2
        
        radius = 2;            
        
    end
    
end


%% Body
[~,X0,freeman_code] = Freeman_chain_code(I,false);

% Freeman chain code move index vector
move_index = [1, 0,-1,-1,-1,0,1,1;  % X / horizontal move
             -1,-1,-1, 0, 1,1,1,0]; % Y / vertical move

a = X0(1,1);
b = X0(2,1);

freeman_code = cell2mat(freeman_code);
L = length(freeman_code);
curvature = zeros(1,L);

[H,W] = size(I);
contour = zeros(H,W);
Sequence = zeros(3,L);
Sequence(1:2,1) = [a;b];
contour(a,b) = 1;


for k = 2:L
    
    Sequence(1:2,k) = Sequence(1:2,k-1)+[move_index(2,freeman_code(1,k));move_index(1,freeman_code(1,k))];
    contour(Sequence(1,k),Sequence(2,k)) = 1;
    
end

T = zeros(H,W,3);
cross_prod = zeros(3,L);


for k = 1:L
    
    % cross product computed discrete curvature 
    cross_prod(:,k) = cross(Sequence(1:3,mod(k+radius,L)+1)-Sequence(1:3,k),...
                            Sequence(1:3,mod(k-radius,L)+1)-Sequence(1:3,k));
    
    cv = sign(cross_prod(3,k));
    
    if cv > 0
        
        T(Sequence(1,k),Sequence(2,k),1) = 1;
        curvature(1,k) = 1;
        
    elseif cv < 0
        
        T(Sequence(1,k),Sequence(2,k),3) = 1;
        curvature(1,k) = -1;
        
    elseif cv == 0
        
        T(Sequence(1,k),Sequence(2,k),2) = 1;
        curvature(1,k) = 0;
        
    end
    
end


%% Display
if option_display
    
    figure;
    set(gcf,'Color',[1 1 1]);
    imshow(T), hold on;
    line([0 0],[0 0],'Color','r','Linewidth',3);
    line([0 0],[0 0],'Color','g','Linewidth',3);
    line([0 0],[0 0],'Color','b','Linewidth',3);
    title(['Discrete curvature; radius = ',num2str(radius),' pixels'],'FontSize',16);
    legend('negative curvature','null curvature','positive curvature','Location', 'NorthEast','Color',[0 0 0],'TextColor',[1 1 1],'FontSize',16,'EdgeColor',[1 1 1]);
    
end


end % discrete_curvature
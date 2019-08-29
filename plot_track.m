clear

load('DTM_ZANDVOORT.mat');
outside_z = wp_pos_z - left2.*wp_perp_z;
inside_z = wp_pos_z - right2.*wp_perp_z;

x = [inside_x; flip(outside_x)];
y = [inside_y; flip(outside_y)];
z = [inside_z; flip(outside_z)]; 
c = z;
patch(x, y, z, c);
hold on
axis equal
lightangle(270,45)
lighting gouraud
material dull 
shading interp

F = scatteredInterpolant(x,y,z);
path_z = F(path_x,path_y);

plot3(path_x, path_y, path_z, 'r', 'LineWidth', 2);



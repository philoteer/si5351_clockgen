
module standoff_holder(xyz=[0,0,0]) {
    insert_height = 10;
    bottom_thickness = 2;
    cube_dim = [6,6];
    standoff_r = 1.4;

    translate([xyz[0], xyz[1], xyz[2]+bottom_thickness]){
    difference(){
    translate([0,0,-bottom_thickness + (insert_height + bottom_thickness)/2]){
        cube([cube_dim[0],cube_dim[1],insert_height+bottom_thickness],center=true);
    }

    cylinder(20,standoff_r ,standoff_r ,$fn=100);
    }
    }
}

module heat_set_insert(translate_pos = [0,0,0], insert_xy_dim = [6.5,6.5], insert_height = 10, hole_r=1.5, hole_h=7.5, cylinder_fn = 15){
    insert_width = insert_xy_dim[0];
    insert_depth = insert_xy_dim[1];
    insert_height = insert_height;
    
    translate(translate_pos){
        difference(){
        cube([insert_width,insert_depth,insert_height]);
            translate([insert_width/2,insert_depth/2,insert_height - hole_h]){
                cylinder(hole_h+1,hole_r,hole_r, $fn=cylinder_fn);
            }
        }
    }
}

bottom_thickness = 2;
chassis_lcd_dim = [85,40,bottom_thickness];
chassis_perfboard_dim = [55,75,bottom_thickness];


cube(chassis_lcd_dim);
translate([5,5,0]){
standoff_holder(xyz=[0,0,0]);
standoff_holder(xyz=[0,31.0,0]);
standoff_holder(xyz=[74.4,31.0,0]);
standoff_holder(xyz=[74.4,0,0]);
}

translate([17,20,0]){
    translate([-2,-2,0]){
cube(chassis_perfboard_dim);}
heat_set_insert(translate_pos=[0,0,0]);
heat_set_insert(translate_pos=[45.2,64.5,0]);
heat_set_insert(translate_pos=[45.2,0,0]);
heat_set_insert(translate_pos=[0,64.5,0]);
    }
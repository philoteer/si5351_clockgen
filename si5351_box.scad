module heat_set_insert(translate_pos = [0,0,0], insert_xy_dim = [6.5,6.5], insert_height = 37, hole_r=1.5, hole_h=7.5, cylinder_fn = 15){
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

z_size = 35;
thickness = 2;
chassis_lcd_dim = [93,48,z_size+thickness];
chassis_perfboard_dim = [76,90,z_size+thickness];

difference(){
    union(){
    cube(chassis_lcd_dim);
    translate([15-6.5,18,0]){
    cube(chassis_perfboard_dim);
        }
    }

    //make wall
    translate([thickness,thickness,thickness]){
    union(){
    cube([chassis_lcd_dim[0]-(thickness*2),chassis_lcd_dim[1]-(thickness*2),chassis_lcd_dim[2]]);
    translate([15-6.5,18,0]){
    cube([chassis_perfboard_dim[0]-(thickness*2),chassis_perfboard_dim[1]-(thickness*2),chassis_perfboard_dim[2]]);
        }
    }
    }

    // SMA hole
    translate([thickness,thickness,thickness+10]){
    translate([15-6.5+10,18,0]){
    cube([chassis_perfboard_dim[0]-(thickness*2)-20,chassis_perfboard_dim[1],chassis_perfboard_dim[2]]);
        }
    }

// USB hole
translate([50,57+thickness,thickness+10]){
cube([100,13,30]);
    }

}
heat_set_insert([9,46,0]);
heat_set_insert([9+76-6.5-2,46,0]);

heat_set_insert([9,100,0]);
heat_set_insert([9+76-6.5-2,100,0]);

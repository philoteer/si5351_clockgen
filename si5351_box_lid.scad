module heat_set_insert_hole(translate_pos = [0,0,0], insert_xy_dim = [6.5,6.5], insert_height = 37, hole_r=1.2, hole_h=7.5, cylinder_fn = 15){
    insert_width = insert_xy_dim[0];
    insert_depth = insert_xy_dim[1];
    insert_height = insert_height;
    
    translate(translate_pos){
        translate([insert_width/2,insert_depth/2,0]){
            cylinder(hole_h+1,hole_r,hole_r, $fn=cylinder_fn);
        }
    }
}

z_size = 0;
thickness = 2;
chassis_lcd_dim = [93,48,z_size+thickness];
chassis_perfboard_dim = [76,90,z_size+thickness];
chassis_lcd_opening = [68,24,999];

difference(){
    union(){
    cube(chassis_lcd_dim);
    translate([15-6.5,18,0]){
    cube(chassis_perfboard_dim);
        }
    }
    //lcd opening
    translate([14.2,13.2,-55]){
    cube(chassis_lcd_opening);
    }

    //button opening
    translate([22.0,53,-55]){
    cube([9,9,100]);
    }
heat_set_insert_hole([9,46,-1]);
heat_set_insert_hole([9+76-6.5-2,46,-1]);

heat_set_insert_hole([9,100,-1]);
heat_set_insert_hole([9+76-6.5-2,100,-1]);

}


xdim=75;
ydim=60;
zdim=70;
th=2.5;

BOX=1;
COVER=2;
item=BOX;
item=COVER;

if (item==BOX) {
    difference() {
        union() {
            difference() {
                cube([xdim+2*th,ydim+2*th,zdim+th],true);
                translate([0,0,th/2]) cube([xdim,ydim,zdim],true);
            }
            translate([-(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=5,$fn=30,center=true);
            }
            translate([(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=5,$fn=30,center=true);
            }
            translate([-(xdim/2-th/2),(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=5,$fn=30,center=true);
            }
            translate([(xdim/2-th/2),(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=5,$fn=30,center=true);
            }
        }
        translate([-xdim/2,-ydim/2+21,0]) {
            translate([0,20,-5]) switch();
            // aerial
            translate([0,1,-zdim/2+54.5]) rotate([90,0,90]) cylinder(h=10,d=11,$fn=30,center=true);
            // LED
            translate([0,20,-25]) rotate([90,0,90]) cylinder(h=10,d=5.1,$fn=30,center=true);
        }

        // USB
        translate([-xdim/2+30,-ydim/2+25.5+2,-zdim/2]) usb();
        translate([0,-ydim/2,0]) tripod();

        // holes
        translate([-(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
            cylinder(h=zdim,d=2,$fn=30,center=true);
        }
        translate([(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
            cylinder(h=zdim,d=2,$fn=30,center=true);
        }
        translate([-(xdim/2-th/2),(ydim/2-th/2),th/2]) {
            cylinder(h=zdim,d=2,$fn=30,center=true);
        }
        translate([(xdim/2-th/2),(ydim/2-th/2),th/2]) {
            cylinder(h=zdim,d=2,$fn=30,center=true);
        }
        
    }

    translate([xdim/2-17.5/2,ydim/2-30/2-10,-zdim/2+20+th/2]) battery_holder();
} else if(item==COVER) {
    rotate([180,0,0]) {
        difference() {
            union() {
                difference() {
                    cube([xdim+2*th,ydim+2*th,th],true);
                    // screw holes
                    translate([-(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                        cylinder(h=zdim,d=3,$fn=30,center=true);
                    }
                    translate([(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                        cylinder(h=zdim,d=3,$fn=30,center=true);
                    }
                    translate([-(xdim/2-th/2),(ydim/2-th/2),th/2]) {
                        cylinder(h=zdim,d=3,$fn=30,center=true);
                    }
                    translate([(xdim/2-th/2),(ydim/2-th/2),th/2]) {
                        cylinder(h=zdim,d=3,$fn=30,center=true);
                    }
                    
                    
                    
                }
                // breakout board mounts
                translate([0,22.86/2+2.54,-13/2-th/2]) {
                    translate([22.86/2,22.86/2,0]) {
                        cylinder(h=13,d=4.5,$fn=30,center=true);
                    }
                    translate([22.86/2,-22.86/2,0]) {
                        cylinder(h=13,d=4.5,$fn=30,center=true);
                    }
                    translate([-22.86/2,22.86/2,0]) {
                        cylinder(h=13,d=4.5,$fn=30,center=true);
                    }
                    translate([-22.86/2,-22.86/2,0]) {
                        cylinder(h=13,d=4.5,$fn=30,center=true);
                    }
                }
                
                // photodiode pinhole
                translate([0,0,-7/2-th/2]) cylinder(d=15,h=7,center=true);
            }
            // photodiode hole
            translate([0,0,0]) {
                cylinder(h=zdim,d=5.1,$fn=30,center=true);
            }
            // breakout board mounts
            translate([0,22.86/2+2.54,-13/2-th/2]) {
                translate([22.86/2,22.86/2,0]) {
                    cylinder(h=13,d=1.7,$fn=30,center=true);
                }
                translate([22.86/2,-22.86/2,0]) {
                    cylinder(h=13,d=1.7,$fn=30,center=true);
                }
                translate([-22.86/2,22.86/2,0]) {
                    cylinder(h=13,d=1.7,$fn=30,center=true);
                }
                translate([-22.86/2,-22.86/2,0]) {
                    cylinder(h=13,d=1.7,$fn=30,center=true);
                }
            }
            
            
        }  
    }  
}

module battery_holder() 
{
    difference() {
        cube([17.5+th*2,30+th*2,40+th*2],true);
        translate([0,0,th]) cube([17.5,30,40+th*2],true);
    }
}

module switch() 
{
    rotate([90,0,90]) {
        translate([0,15/2,0]) cylinder(d=3,h=10,$fn=30,center=true);
        translate([0,-15/2,0]) cylinder(d=3,h=10,$fn=30,center=true);
        translate([0,0,0]) cube([4,7,10],true);
    }
}

module usb() 
{
    rotate([-90,0,0]) hull() {
        cube([8,10,2],true);
        translate([0,0,-2.5]) cube([7,10,2],true);
    }
}

module tripod()
{
    rotate([90,0,0]) {
        cylinder(h=10,d=9,center=true);
        translate([0,8,0]) cylinder(h=10,d=3,$fn=30,center=true);
        rotate([0,0,120]) translate([0,8,0]) cylinder(h=10,d=3,$fn=30,center=true);
        rotate([0,0,-120]) translate([0,8,0]) cylinder(h=10,d=3,$fn=30,center=true);
    }
}

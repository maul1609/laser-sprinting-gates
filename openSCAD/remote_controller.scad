xdim=100;
ydim=90;
zdim=25;
zdim2=16;
th=2.5;

BOTTOM=1;
TOP=2;
LCD_TOP=1;
LCD_BOTTOM=2;
part=TOP;
part2=LCD_TOP;
if(part==BOTTOM) {
    difference() 
    {
        union() {
            //box
            difference() {
                cube([xdim+2*th,ydim+2*th,zdim+th],true);
                translate([0,0,th/2+0.01]) cube([xdim,ydim,zdim],true);
            }
            // screw hole/mounts
            translate([0,-th/2+17/2,0]) {
                translate([-(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                    cylinder(h=zdim,d=5,$fn=30,center=true);
                }
                translate([(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                    cylinder(h=zdim,d=5,$fn=30,center=true);
                }
            }
            
            translate([-(xdim/2-th/2),(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=5,$fn=30,center=true);
            }
            translate([(xdim/2-th/2),(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=5,$fn=30,center=true);
            }
            translate([0,18,0]) {
                translate([-(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                    cylinder(h=zdim,d=5,$fn=30,center=true);
                }
                translate([(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                    cylinder(h=zdim,d=5,$fn=30,center=true);
                }
            }
            // arduino mounts
            translate([-(xdim/2)+21-th,(ydim/2)-17,-(zdim/2)+5/2+th/2]) {
                cylinder(h=5,d=4.5,$fn=30,center=true);
            }
            translate([-(xdim/2)+21-th-1.3,(ydim/2)-17-48,-(zdim/2)+5/2+th/2]) {
                cylinder(h=5,d=4.5,$fn=30,center=true);
            }
            translate([-(xdim/2)+21-th+64.4-13.6,(ydim/2)-17-15.3,-(zdim/2)+5/2+th/2]) {
                cylinder(h=5,d=4.5,$fn=30,center=true);
            }
            translate([-(xdim/2)+21-th+64.4-13.6,(ydim/2)-17-(44.12-1),-(zdim/2)+5/2+th/2]) {
                cylinder(h=5,d=4.5,$fn=30,center=true);
            }

            
            
            
            // slot
            difference() {
                translate([0,0,zdim/2+th/2-1.5+3-1]) cube([xdim+2,ydim+2,3],true);
                translate([0,0,zdim/2+th/2-1.5+3-1]) cube([xdim,ydim,3.1],true);
            }                
        }
        

        // screw hole/mounts
        translate([0,-th/2+17/2,0]) {
            translate([-(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=1.5,$fn=30,center=true);
            }
            translate([(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=1.5,$fn=30,center=true);
            }
        }
        translate([-(xdim/2-th/2),(ydim/2-th/2),th/2]) {
            cylinder(h=zdim,d=1.5,$fn=30,center=true);
        }
        translate([(xdim/2-th/2),(ydim/2-th/2),th/2]) {
            cylinder(h=zdim,d=1.5,$fn=30,center=true);
        }
        translate([0,18,0]) {
            translate([-(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=1.5,$fn=30,center=true);
            }
            translate([(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=1.5,$fn=30,center=true);
            }
        }

        // arduino mounts
        translate([-(xdim/2)+21-th,(ydim/2)-17,-(zdim/2)+5/2+th/2]) {
            cylinder(h=5,d=1.5,$fn=30,center=true);
        }
        translate([-(xdim/2)+21-th-1.3,(ydim/2)-17-48,-(zdim/2)+5/2+th/2]) {
            cylinder(h=5,d=1.5,$fn=30,center=true);
        }
        translate([-(xdim/2)+21-th+64.4-13.6,(ydim/2)-17-15.3,-(zdim/2)+5/2+th/2]) {
            cylinder(h=5,d=1.5,$fn=30,center=true);
        }
        translate([-(xdim/2)+21-th+64.4-13.6,(ydim/2)-17-(44.12-1),-(zdim/2)+5/2+th/2]) {
            cylinder(h=5,d=1.5,$fn=30,center=true);
        }

        // usb
        translate([-(xdim/2),(ydim/2)-17-12.5,-(zdim/2)+th/2+12/2+7]) cube([10,13,12],true);

        // aerial
        translate([21-th-(xdim/2)+74-13.6-1,(ydim/2),-1]) rotate([90,0,0]) cylinder(h=10,d=11,center=true);
        
        // switch
        translate([-xdim/2,-5,11]) rotate([90,0,0]) switch();
        

    }
    
    translate([-15,-(ydim/2)+17./2,-(zdim/2)+th/2+15/2]) battery_holder();
} else if(part==TOP) {
    difference() 
    {
        union() {
            //box
            difference() {
                cube([xdim+2*th,ydim+2*th,zdim2+th],true);
                translate([0,0,th/2+0.01]) cube([xdim,ydim,zdim2],true);
            }
            // screw hole/mounts
            translate([0,-th/2+17/2,0]) {
                translate([-(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                    cylinder(h=zdim2,d=5,$fn=30,center=true);
                }
                translate([(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                    cylinder(h=zdim2,d=5,$fn=30,center=true);
                }
            }
            
            translate([-(xdim/2-th/2),(ydim/2-th/2),th/2]) {
                cylinder(h=zdim2,d=5,$fn=30,center=true);
            }
            translate([(xdim/2-th/2),(ydim/2-th/2),th/2]) {
                cylinder(h=zdim2,d=5,$fn=30,center=true);
            }
            translate([0,18,0]) {
                translate([-(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                    cylinder(h=zdim2,d=5,$fn=30,center=true);
                }
                translate([(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                    cylinder(h=zdim2,d=5,$fn=30,center=true);
                }
            }
            
            
            // mounts for LCD
            
            // hole for LCD
            translate([0,(ydim/2)-34,-zdim2/2+(9-th)/2+th/2]) {
                translate([75/2,31/2,0]) cylinder(d=5,h=9-th,center=true);
                translate([-75/2,31/2,0]) cylinder(d=5,h=9-th,center=true);
                translate([75/2,-31/2,0]) cylinder(d=5,h=9-th,center=true);
                translate([-75/2,-31/2,0]) cylinder(d=5,h=9-th,center=true);
            }
            
            
        }
        // slot
        translate([0,0,zdim2/2+th/2+2.6/2-2.6]) cube([xdim+2.2,ydim+2.2,2.6],true);
        // screw hole/mounts
        translate([0,-th/2+17/2,0]) {
            translate([-(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=2.5,$fn=30,center=true);
            }
            translate([(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=2.5,$fn=30,center=true);
            }
        }
        translate([-(xdim/2-th/2),(ydim/2-th/2),th/2]) {
            cylinder(h=zdim,d=2.5,$fn=30,center=true);
        }
        translate([(xdim/2-th/2),(ydim/2-th/2),th/2]) {
            cylinder(h=zdim,d=2.5,$fn=30,center=true);
        }
        translate([0,18,0]) {
            translate([-(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=2.5,$fn=30,center=true);
            }
            translate([(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=2.5,$fn=30,center=true);
            }
        }
        
        // hole for button:
        translate([-xdim/2+8,-ydim/2+32,0]) cylinder(d=7.1,h=50,$fn=30,center=true);
        
        // hole for LCD
        translate([0,(ydim/2)-34,-zdim2/2+(20)/2+th/2]) {
            cube([72,26,100],true);
            translate([75/2,31/2,0]) cylinder(d=1.6,h=20,center=true);
            translate([-75/2,31/2,0]) cylinder(d=1.6,h=20,center=true);
            translate([75/2,-31/2,0]) cylinder(d=1.6,h=20,center=true);
            translate([-75/2,-31/2,0]) cylinder(d=1.6,h=20,center=true);
        }
        
        // split them
        //translate([0,-ydim/2+17,0]) cube([2*xdim,0.5,zdim],true);
        if(part2==LCD_TOP) {
            translate([0,-ydim/2+17-200/2,0]) cube([2*xdim,200,zdim],true);
        } else if(part2==LCD_BOTTOM) {
            translate([0,-ydim/2+17+200/2-0.5,0]) cube([2*xdim,200,zdim],true);
        }
        
    }    
}

module battery_holder() 
{
    difference() {
        cube([60+th*2,17.+th*2,15+th*2],true);
        translate([0,0,th]) cube([60,17,15+th*2],true);
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



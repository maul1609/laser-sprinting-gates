xdim=70;
ydim=27;
zdim=28;
th=2.5;

BOTTOM=1;
TOP=2;
part=TOP;

if(part==BOTTOM) {
    difference() 
    {
        union() {
            difference() {
                cube([xdim+2*th,ydim+2*th,zdim+th],true);
                translate([0,0,th/2]) cube([xdim,ydim,zdim],true);
            }
            translate([-(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=6,$fn=30,center=true);
            }
            translate([(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=5,$fn=30,center=true);
            }
            translate([-(xdim/2-th/2),(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=6,$fn=30,center=true);
            }
            translate([(xdim/2-th/2),(ydim/2-th/2),th/2]) {
                cylinder(h=zdim,d=5,$fn=30,center=true);
            }
            translate([xdim/2-0.5+0.25,0,0]) cube([5.5,ydim+2*th,zdim+th],true);
            
            translate([-8,0,0]) {
                // battery holder
                translate([-22,0,0]) cube([th,ydim+2*th,zdim+th],true);
                translate([17+th-22,0,0]) cube([th,ydim+2*th,zdim+th],true);

                // board holder
                difference() {
                    union() {
                        translate([17+th+7,0,0]) cube([2,ydim+2*th,zdim+th],true);
                        translate([17+th+7+2+2,0,0]) cube([2,ydim+2*th,zdim+th],true);
                    }
                    translate([17+th+7+2+2,0,0]) cube([20,20,zdim+th],true);
                    
                }
            }
            
            // slot
            difference() {
                translate([0,0,zdim/2+th/2-1.5+3-1]) cube([xdim+2,ydim+2,3],true);
                translate([0,0,zdim/2+th/2-1.5+3-1]) cube([xdim,ydim,3],true);
                translate([xdim/2,0,zdim/2+th/2-1.5+3-1]) cube([6,16,10],true);
            }                
        }
        
        translate([0,0,-zdim/2]) rotate([90,0,90]) tripod();

        translate([-(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
            cylinder(h=zdim,d=1.5,$fn=30,center=true);
        }
        translate([(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
            cylinder(h=zdim,d=1.5,$fn=30,center=true);
        }
        translate([-(xdim/2-th/2),(ydim/2-th/2),th/2]) {
            cylinder(h=zdim,d=1.5,$fn=30,center=true);
        }
        translate([(xdim/2-th/2),(ydim/2-th/2),th/2]) {
            cylinder(h=zdim,d=1.5,$fn=30,center=true);
        }

        // laser
        translate([(xdim)/2-0.5+0.5,0,(zdim+th)/2]) rotate([0,90,0]) cylinder(d=6,h=5,$fn=30,center=true);
        translate([(xdim)/2-0.5+0.5,0,(zdim+th)/2]) rotate([0,90,0]) cylinder(d=5,h=10,$fn=30,center=true);
        
        // switch
        translate([3,-ydim/2,0]) rotate([90,0,90]) switch();
        
        for (i=[1:3])
            translate([xdim/2-7.5,0,-zdim/2+10+(i-1)*6]) rotate([90,0,0]) cylinder(d=3,h=100,$fn=16,center=true); 

    }
} else if(part==TOP) {
    difference() 
    {
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
            translate([xdim/2-0.5+0.25,0,0]) cube([5.5,ydim+2*th,zdim+th],true);
            
            translate([-8,0,0]) {

                // board holder
                difference() {
                    union() {
                        translate([17+th+7,0,0]) cube([2,ydim+2*th,zdim+th],true);
                        translate([17+th+7+2+2,0,0]) cube([2,ydim+2*th,zdim+th],true);
                    }
                    translate([17+th+7+2+2,0,0]) cube([20,20,zdim+th],true);
                    
                }
            }
        }
        

        translate([-(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
            cylinder(h=zdim*2,d=2.5,$fn=30,center=true);
        }
        translate([(xdim/2-th/2),-(ydim/2-th/2),th/2]) {
            cylinder(h=zdim*2,d=2.5,$fn=30,center=true);
        }
        translate([-(xdim/2-th/2),(ydim/2-th/2),th/2]) {
            cylinder(h=zdim*2,d=2.5,$fn=30,center=true);
        }
        translate([(xdim/2-th/2),(ydim/2-th/2),th/2]) {
            cylinder(h=zdim*2,d=2.5,$fn=30,center=true);
        }

        // laser
        translate([(xdim)/2-0.5+0.5,0,(zdim+th)/2]) rotate([0,90,0]) cylinder(d=6,h=5,$fn=30,center=true);
        translate([(xdim)/2-0.5+0.5,0,(zdim+th)/2]) rotate([0,90,0]) cylinder(d=5,h=10,$fn=30,center=true);
        
        
        for (i=[1:3])
            translate([xdim/2-7.5,0,-zdim/2+10+(i-1)*6]) rotate([90,0,0]) cylinder(d=3,h=100,$fn=16,center=true); 
    
        // slot
        difference() {
            translate([0,0,zdim/2+th/2-1.5]) cube([xdim+2.5,ydim+2.5,3],true);
            translate([xdim/2,0,zdim/2+th/2-1.5]) cube([10,15,10],true);
        }
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


module tripod()
{
    rotate([90,0,0]) {
        cylinder(h=10,d=9,center=true);
        translate([0,8,0]) cylinder(h=10,d=3,$fn=30,center=true);
        rotate([0,0,120]) translate([0,8,0]) cylinder(h=10,d=3,$fn=30,center=true);
        rotate([0,0,-120]) translate([0,8,0]) cylinder(h=10,d=3,$fn=30,center=true);
    }
}

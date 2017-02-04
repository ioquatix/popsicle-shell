
use <zcube.scad>;

popsicle_bevel = 4;
popsicle_size = [25, 45, 14];
$fn = 16;

module diamond(size = bevel_size) {
	render() polyhedron(
		points=[
			// Outside points:
			[size,size,0],[size,-size,0],[-size,-size,0],[-size,size,0],
			// Apex points:
			[0,0,size],[0,0,-size]
		],
		faces=[
			// Top faces:
			[0,1,4],[1,2,4],[2,3,4],[3,0,4],
			// Bottom faces:
			[0,1,5],[1,2,5],[2,3,5],[3,0,5],
		]
	);
}

module popsicle(size = popsicle_size, bevel = popsicle_bevel) {
	inset_size = size - [bevel*2, bevel*2, bevel*2];
	
	cube_size = [
		inset_size[0],
		inset_size[1] - inset_size[0]/2,
		inset_size[2]
	];
	
	minkowski() {
		translate([0, -cube_size[0]/4, -cube_size[2]/2]) union() {
			zcube(cube_size);
			translate([0, cube_size[1]/2, 0]) cylinder(r=cube_size[0]/2, h=size[2]-bevel*2);
		}
		sphere(r=bevel,$fn=16);
	}
	
	//%cube(size, center=true);
}

module slots(size, r=5) {
	offset = size[1]/4;
	
	translate([-size[0]/2, offset+r/4, 0]) zcube([r, r/2, size[2]/1.5], z=-size[2]/2);
	translate([-size[0]/2, -offset+r/4, 0]) zcube([r, r/2, size[2]/1.5], z=-size[2]/2);
}

module shell(size = popsicle_size, thickness = 1) {
	translate([0, 0, size[2]/2]) difference() {
		union() { 
			translate([0, 0, thickness]) minkowski() {
				popsicle(size);
				sphere(r=thickness,$fn=16);
			}
			
			slots(size);
			rotate([0, 0, 180]) slots(size);
		}
		
		translate([0, 0, thickness]) {
			popsicle(size);
			zcube(size+[2, 2, 0]);
			scale(1.1) stick();
		}
	}
}

module stick(size = popsicle_size) {
	stick_size = [size[0]/5, size[1]*0.6, size[2]/10];
	translate([0, -size[1]/2, 0]) {
		cube(stick_size, center=true);
		translate([0, stick_size[1]/2, -stick_size[2]/2]) cylinder(r=stick_size[0]/2, h=stick_size[2]);
		translate([0, -stick_size[1]/2, -stick_size[2]/2]) cylinder(r=stick_size[0]/2, h=stick_size[2]);
	}
}

shell();
//popsicle();

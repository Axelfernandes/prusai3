// roller to replace/simulate 608 bearings, last modified 2014-03-28
// when the bore is cleaned up, it must be a loose rolling fit on a pin which
//   would fit the 8.00mm bore in a 608 bearing, i.e. about an 8.00mm plastic pin
// roller bore diameter experimentally determined, adjust for your printer/filament,
//   temperature, layer thickness, number of shells, fill percentage, etc.
// roller width could be adjusted to simulate a wider or double bearing

$fn=100;                 // set circle approximations to be very smooth

// define sizing of the roller

borediameter=8.50;       // bore diameter, larger than 608 bearing, empirical value
br=borediameter/2;       // bore radius
bx=br+.5;                // expanded bore radius, outside of two "bearing surfaces"

rw=7.00;                 // roller width     (7mm to simulate 608 bearing)
rd=22.0;                 // roller diameter (22mm to simulate 608 bearing)
rr=rd/2;                 // roller radius
xw=1;                    // widths of two inner "bearing surfaces" within the bore

// define heights and elevations of components of the roller bore
// in order: "bearing surface" / tapered areas / "bearing surface"

z1=0;     h1=xw;
z2=z1+h1; h2=(rw-(2*xw))/2;
z3=z2+h2; h3=h2;
z4=z3+h3; h4=h1;

// stack up the voids within the roller

module voids()
 {
  translate([0,0,z1-.01]) cylinder(h=h1+.01,r=br);
  translate([0,0,z2])     cylinder(h=h2,r1=br,r2=bx);
  translate([0,0,z3])     cylinder(h=h3,r1=bx,r2=br);
  translate([0,0,z4])     cylinder(h=h4+.01,r=br);    
 }

// create the roller

difference() {cylinder(h=rw,r=rr); voids();}

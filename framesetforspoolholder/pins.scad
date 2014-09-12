// 2 pins for filament spool roller; last modified 2014-03-26
// pins to go through frame and 608ZZ bearing with 8mm bore, and support with .25" bore

// define smoothness of pin
$fn=60;

// for 608ZZ bearing actual bore size is 8mm; support hole size designed as .25" (=6.35mm)
// - empirically determined pin diameters to fit printed and reamed holes in PLA and ABS
// - always print 2 pins at a time for consistent "diameter" results without remelting
// - the pins might have a somewhat eliptical cross-section, rather than circular, but
//   tune the values in the next line to make them workable (when 2 are printed)
borediameter=8.00; supportdiameter=6.35;  // adjust to fit frame, 608ZZ bearing, support

br=borediameter/2;       // radius of bore of bearing and frame hole
sr=supportdiameter/2;    // radius of support hole
cr=br+2;                 // radius of cap of pin (outside of frame)

bw=7.00;  // 7mm width of single 608 bearing; adjust for doubled bearing or custom roller

// define radii and heights of segments of the pin

p0r=cr;  p0h=2.0;               // cap of pin, to be outside of frame
p1r=br;  p1h=5.00;              // frame
p2r=br;  p2h=0.75;              // "washer" printed inside frame
p3r=br;  p3h=0.25;              // gap to bearing
p4r=br;  p4h=bw;                // bearing width
p5r=br;  p5h=0.25;              // gap to bearing
p6r=br;  p6h=0.75;              // "washer" printed inside support
p7r=sr;  p7h=10.0;              // support
p8r1=sr; p8r2=sr-0.25; p8h=0.5; // tapered tip 

p00h=p0h;
p01h=p0h+p1h;
p02h=p0h+p1h+p2h;
p03h=p0h+p1h+p2h+p3h;
p04h=p0h+p1h+p2h+p3h+p4h;
p05h=p0h+p1h+p2h+p3h+p4h+p5h;
p06h=p0h+p1h+p2h+p3h+p4h+p5h+p6h;
p07h=p0h+p1h+p2h+p3h+p4h+p5h+p6h+p7h;

// stack up segments of the pin, giving one complete pin assembly (decreasing diameters)

module onepin()
 {translate([0,0,p07h]) cylinder(h=p8h,r1=p8r1,r2=p8r2);
  translate([0,0,p06h]) cylinder(h=p7h,r=p7r);
  translate([0,0,p05h]) cylinder(h=p6h,r=p6r);
  translate([0,0,p04h]) cylinder(h=p5h,r=p5r);
  translate([0,0,p03h]) cylinder(h=p4h,r=p4r);
  translate([0,0,p02h]) cylinder(h=p3h,r=p3r);
  translate([0,0,p01h]) cylinder(h=p2h,r=p2r);
  translate([0,0,p00h]) cylinder(h=p1h,r=p1r);
                        cylinder(h=p0h,r=p0r);
 }

// create two pins, diameters will vary if printed other than 2 at a time

translate([+10,0,0]) onepin();
translate([-10,0,0]) onepin();

//
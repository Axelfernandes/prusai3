// create full frame for spool and bearings, modified 2014-03-26
//********************************************************************************
// edit/comment "inside width" (IWinches) and "wheelbase" (WBinches) as needed
//
   IWinches=3.10; WBinches=3.5;  // for 8" MakerBot new 1Kg spool     (3.00" wide)
// IWinches=1.65; WBinches=4.0;  // for 9.84"/25cm MakerBot 2lb spool (1.57" wide)
// IWinches=3.95; WBinches=3.0;  // for ~6" wiring-type spool         (3.88" wide)
// IWinches=4.15; WBinches=3.0;  // for warped ~6" wiring-type spool  (4.12" wide)
//

mmperinch=25.4; IWmm=IWinches*mmperinch; WBmm=WBinches*mmperinch;

$fn=50;

//********************************************************************************
// switches to change features

onecorneronly=false;  // switch to print only for corner, for test fit of pin
recessside=true;      // switch for side recesses; NOT PARAMETRIC; for 608 bearings
recessend=true;       // switch for end recesses;  NOT PARAMETRIC; for 608 bearings
extraraft=true;       // switch for 3/4 circles for extra raft at the corners
rr=10.0;              // radius for 3/4 circles for extra raft

//********************************************************************************
// constants with the notation **ADJ** might need adjustment for your printer/filament

bor=22.0/2;           // bearing outer radius (for 608 bearing, 22mm diameter)
bir=8.15/2;           // bearing inner radius (for 608 bearing, 8mm diameter) **ADJ**
bw=7.0;               // bearing width        (for 608 bearing, 7mm wide)
bcw=bw+2.0;           // bearing clearance width   (2mm added for "washers" and space)
bcr=bor+1.0;          // bearing clearance radius  (1mm clearance added)

sir=6.50/2;           // support inside radius (for 1/4" = 6.35mm diameter) **ADJ**

wor=bir+2.0;          // "washer" outer radius
wir=bir+0.25;         // "washer" inner radius
wt=0.75;              // "washer" thickness

ft=5.0;               // frame thickness
st=10.0;              // support thickness
fh=bcr+bor;           // frame height
pl=ft+bcw+st;         // pin length
eo=pl+ft;             // end offset for recess
so=ft+bcr+bor+ft;     // side offset for recess

pinoffset=bcr+ft;     // distance from end to center of pin
halfWB=WBmm/2; halfside=pinoffset+halfWB;
halfIW=IWmm/2; halfend=ft+halfIW;

//****************************************************************************


// construct either full frame, or one corner to for pin test fit
//
if (onecorneronly) quarterframe();
  else {halfframe(); mirror([0,1,0]) halfframe();}


// "halfframe" module
// construct one end of frame
//
module halfframe()
{quarterframe(); mirror([1,0,0]) quarterframe();}


// "quarterframe" module
// place one corner correctly (on z=0, centered x/y)
//
module quarterframe()
{translate([-halfside,-halfend,0]) voidedcorner();}


// "voidedcorner" module
// add void for pin and bearing to corner
//
module voidedcorner()
{difference() {roundedcorner(); translate([bcr+ft,0,bcr]) rotate([-90,0,0]) rollervoid();}}


// "roundedcorner" module
// round off outer corner
//
module roundedcorner()
{
  difference()
   {solidcorner(); translate([2,2,0]) difference()
     {translate([-2,-2,0]) cube([2,2,fh]); cylinder(r=2,h=fh,$fn=100);}}
}


// "solidcorner" module
// create one corner of the frame, before voids
//
module solidcorner()
{
// half side frame - optional recess, NOT PARAMETRIC, only for 608 bearings
  if(recessside && (halfside > (so+5)))
    {difference()
      {cube([halfside+.01,ft,fh]);
       translate([so,-fh/2,fh/2]) rotate([0,90,0]) cylinder(h=halfside,r=15);}}
    else {cube([halfside,ft,fh]);}

// half end frame - optional recess, NOT PARAMETRIC, only for 608 bearings
  if(recessend && (halfend > (eo+5)))
    {difference()
      {cube([ft,halfend+.01,fh]);
       translate([-fh/2,eo,fh/2]) rotate([-90,0,0]) cylinder(h=halfend,r=15);}}
    else {cube([ft,halfend,fh]);}

// support for pin end, upper inner part curved to match bearing
  translate([ft,ft+bcw,0]) cube([bcr,st,fh]);     // half of support toward end
  translate([pinoffset,0,0]) cube([bor,pl,bcr]);  // bottom quarter of support
  translate([pinoffset,0,bcr]) rotate([-90,0,0]) cylinder(r=bor,h=ft+bcw+st,$fn=100);

// optional raft extension (short 3/4 circle cylinder, offset by .5mm)
   if(extraraft)
     {translate([-0.5,-0.5,0]) difference() {cylinder(r=rr,h=.20); cube([rr,rr,.20]);}}
}


// "rollervoid" module
// create void for pin and bearing
//
module rollervoid()
{
  translate([0,0,pl])        cylinder(h=0.01,r=sir);        // make hole go through inner
  translate([0,0,0])         cylinder(h=pl,r=sir,$fn=50);
  translate([0,0,0])         cylinder(h=ft+bcw+.25,r=bir,$fn=50);
  translate([0,0,-0.01])     cylinder(h=0.01,r=bir);        // make hole go through outer

  translate([0,0,ft+bcw-wt]) cylinder(h=wt+.25,r=wir);      // inner "washer"
  translate([0,0,ft+bcw-wt]) difference() {cylinder(h=wt,r=bcr); cylinder(h=wt,r=wor);}

  translate([0,0,ft+wt])     cylinder(h=bcw-2*wt,r=bcr);    // bearing space with clearances

  translate([0,0,ft])        cylinder(h=wt,r=wir);          // outer "washer"
  translate([0,0,ft])        difference() {cylinder(h=wt,r=bcr); cylinder(h=wt,r=wor);}
  
}

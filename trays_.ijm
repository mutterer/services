/*
a ImageJ.js workflow for measuring plants from trays
Jerome Mutterer / 20221014
*/

var x=setup();

macro "trays Action Tool - C0f0H000ff800C000G000ff800" {
id=getImageID;
makeRectangle(getWidth/10,getHeight/10,8*getWidth/10,8*getHeight/10);
Roi.setFillColor("#8000ff00");
waitForUser("adjust rectangle and press OK");
Dialog.create("Parameters");
Dialog.addNumber("Number_of_columns", 4);
Dialog.addNumber("Number_of_rows", 6);
Dialog.addNumber("Width in cm", 40);
Dialog.show();
getSelectionBounds(x, y, width, height);
nx=Dialog.getNumber();
ny=Dialog.getNumber();;
dist=Dialog.getNumber();
run("Set Scale...", "distance=&width known=&dist pixel=1 unit=cm");
roiManager('reset');
setBatchMode(1);
id=getImageID;
run("Select None");
run("Duplicate...", "title=stack");
run("RGB Stack");
run("32-bit");
run("Multiply...", "value=-1.000 stack");
setSlice(2);
run("Multiply...", "value=-2.000 slice");
run("Z Project...", "projection=[Sum Slices]");
run("Set Measurements...", "area centroid perimeter bounding display redirect=None decimal=3");
// setAutoThreshold("Li dark"); // Li fails when plants too small
setThreshold(80, 1.0000E30);
setOption("BlackBackground", true);
run("Convert to Mask");

for (j=0; j<ny; j++) {
  for (i=0; i<nx; i++) {
    makeRectangle(x+i*width/nx, y+j*height/ny, width/nx, height/ny);
    roiManager('add');
    setThreshold(128,255);
    run("Create Selection");
    roiManager('add');
    r = roiManager('count');
    roiManager('select', newArray(r-1, r-2));
    roiManager("AND");
    area = getValue('Area');
    if ((selectionType==-1)||(area<0.1)) {
	makePoint(x+(i+0.5)*width/nx, y+(j+0.5)*height/ny);
	Roi.setName("empty");
    }
    roiManager('add');
    roiManager('select', newArray(r-1, r-2));
    roiManager('delete');
  }
}

selectImage(id);
close("\\Others");

n = roiManager('count');
for (i=0; i<n; i++) {
   roiManager('select', n-i-1);
 if (Roi.getName=="empty") roiManager("Delete");
}

setBatchMode(0);
roiManager("Show All");
roiManager("Measure");

}

function setup() {
print ("--MEASURE PLANTS FROM TRAY IMAGE--");
print ("Version 1.03");
print ("Drag and drop image on the canvas.");
print ("Press the 'play' tool icon to measure plants.");
print ("-----------------------------------------------");
return 1;
}

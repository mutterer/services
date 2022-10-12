var x=setup();

macro "leavEZ Action Tool - C0f0H000ff800C000G000ff800" {
    getVoxelSize(width, height, depth, unit);
    if (unit.startsWith("inch")) {
        width=width*25.4;
        height=height*25.4;
        depth=depth*25.4;
        unit = "mm";
        setVoxelSize(width, height, depth, unit);
    } else {
        exit("Probably not a flatbed scanner image!");
    }
setBatchMode(1);
id=getImageID;
run("Duplicate...", "title=stack");
run("RGB Stack");
run("32-bit");
run("Multiply...", "value=-1.000 stack");
setSlice(2);
run("Multiply...", "value=-2.000 slice");
run("Z Project...", "projection=[Sum Slices]");
setAutoThreshold("Default dark no-reset");
run("Set Measurements...", "area centroid perimeter bounding shape feret's display redirect=None decimal=3");
run("Analyze Particles...", "size=100-Infinity pixel exclude clear add");
selectImage(id);
close("\\Others");
roiManager("Show All");
roiManager("Measure");
saveAs("results",getTitle+".csv");
}

function setup() {
print ("--MEASURE LEAVES FROM FLATBED SCANNER IMAGES--");
print ("Version 1.02");
print ("Drag and drop image on the canvas.");
print ("Press the 'play' tool icon to measure leaves.");
print ("-----------------------------------------------");
return 1;
}

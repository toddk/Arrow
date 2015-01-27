using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

// This class is a graphical representation of an arrow
// using MonkeyC and ConnectIQ. The graphics subsystem from
// Garmin is used to draw and fill the shape of the arrow.
class ArrowShape {

	hidden var arrowWidth = 20;
	hidden var shaftHeight = 80;
	hidden var _screenWidth;
	hidden var _screenHeight;
	hidden var rectX;
	hidden var rectY;

	// Default constructor.
	function initialize(centerX, centerY, screenWidth, screenHeight) {
		rectX = centerX - (arrowWidth / 2);
		rectY = centerY - (shaftHeight / 2);
		_screenWidth = screenWidth;
		_screenHeight = screenHeight;
	}

	// Needs to be called to be drawn into supplied graphics context.
	function onDraw(dc)  {
			
		var arrowLeftX1 = rectX - 20;
		var arrowLeftY1 = rectY;
		var arrowTopX2 = _screenWidth / 2;
		var arrowTopY2 = rectY - 20;
		var arrowRightX3 = rectX + arrowWidth + 20;

        dc.clear();
        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLACK);
		
		var arrowHead = new[4];
        arrowHead[0] = [arrowLeftX1, arrowLeftY1];
        arrowHead[1] = [arrowTopX2, arrowTopY2];
        arrowHead[2] = [arrowRightX3, arrowLeftY1];
        arrowHead[3] = [arrowLeftX1, arrowLeftY1];
        
        dc.fillPolygon(arrowHead);
        dc.fillRectangle(rectX, rectY, arrowWidth, shaftHeight);
	}

}
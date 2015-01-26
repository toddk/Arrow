using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Position as Position;
using Toybox.Math as Math;

class ArrowView extends Ui.WatchFace {

	var posnInfo;
	var bearing;

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    	Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    //! Update the view
    function onUpdate(dc) {
        // Get and show the current time
        var clockTime = Sys.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%.2d")]);
		var screenWidth = dc.getWidth();
		var screenHeight = dc.getHeight();
		
		//Sys.println("Width: " + screenWidth + " Height: " + screenHeight);
		
		var arrowWidth = 20;
		var shaftHeight = 80;
		var rectX = (screenWidth / 2) - (arrowWidth / 2);
		var rectY = (screenHeight / 2) - (shaftHeight / 2);
		
		//Sys.println("rectX: " + rectX + " rectY: " + rectY);
		
		var arrowLeftX1 = rectX - 20;
		var arrowLeftY1 = rectY;
		var arrowLeftX2 = screenWidth / 2;
		var arrowLeftY2 = rectY - 20;
		var arrowLeftX3 = rectX + arrowWidth + 20;

        dc.clear();
        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLACK);
		
		var arrowHead = new[4];
        arrowHead[0] = [arrowLeftX1, arrowLeftY1];
        arrowHead[1] = [arrowLeftX2, arrowLeftY2];
        arrowHead[2] = [arrowLeftX3, arrowLeftY1];
        arrowHead[3] = [arrowLeftX1, arrowLeftY1];
        
        //dc.drawLine(arrowLeftX1, arrowLeftY1, arrowLeftX2, arrowLeftY2);
        //dc.drawLine(arrowLeftX2, arrowLeftY2, arrowLeftX3, arrowLeftY1);
        //dc.drawLine(arrowLeftX1, arrowLeftY1, arrowLeftX3, arrowLeftY1);
        
        dc.fillPolygon(arrowHead);
        dc.fillRectangle(rectX, rectY, arrowWidth, shaftHeight);
        
        
        //dc.drawRectangle(45,50,20,50);
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

	function onPosition(info) {
		if (posnInfo != null) {
			// calculate the bearing
			var prevLat = posnInfo.position.toRadians()[0];
			var prevLon = posnInfo.position.toRadians()[1];
			
			var currLat = info.position.toRadians()[0];
			var currLon = info.position.toRadians()[1];
			
			// ATAN2(COS(lat1)*SIN(lat2)-SIN(lat1)*COS(lat2)*COS(lon2-lon1), 
       		// SIN(lon2-lon1)*COS(lat2)) 

			var y = Math.sin(currLon - prevLon) * Math.cos(currLat);
			var x = Math.cos(prevLat) * Math.sin(currLat) - Math.sin(prevLat) * Math.cos(currLat) * Math.cos(currLon - prevLon);
			Sys.println("X " + x.toString() + " Y " + y.toString());
			var bearing = Math.atan(x);
			Sys.println("BEARING: " + bearing.toString());
		}
	
		posnInfo = info;
		//Sys.println("Lat " + posnInfo.position.toDegrees()[0].toString() + " lon " + posnInfo.position.toDegrees()[1].toString());
		//Sys.println("Heading: " + posnInfo.heading);	
		//Sys.println("Speed: " + posnInfo.speed);
		Ui.requestUpdate();
	}
}
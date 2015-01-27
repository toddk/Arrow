using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Position as Position;
using Toybox.Math as Math;

class ArrowView extends Ui.WatchFace {

	var posnInfo;
	var bearing;
	var arrowShape;

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        arrowShape = new ArrowShape();
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    	Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    //! Update the view
    function onUpdate(dc) {
        arrowShape.onDraw(dc);
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
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Application as App;

class MasterOfView extends Ui.WatchFace {
	var font;
	var span = 2;
	var stary_y;
	var themes = [
		[0x6600CC, 0xAAAAAA, 0x000000], // text_1, text_2, bg
		[0xFFFFFF, 0xAAAAAA, 0x000000],
		[0x000000, 0x555555, 0xFFFFFF]
	];
	var theme;

	function initialize() {
		WatchFace.initialize();

		var ss = Sys.getDeviceSettings().screenShape;
		if (ss == Sys.SCREEN_SHAPE_ROUND ) {
			stary_y = 34;
		}
		else if (ss == Sys.SCREEN_SHAPE_SEMI_ROUND ) {
			stary_y = 17;
		}
		/*
		else if (ss == Sys.SCREEN_SHAPE_RECTANGLE ) {
			stary_y = 0;
		}
		*/
		else {
			num = 0;
		}

		//var sc_width = Sys.getDeviceSettings().screenWidth;
		//var sc_height = Sys.getDeviceSettings().screenHeight;
		//Sys.println("width:" + sc_width);
		//Sys.println("height:" + sc_height);
	}

	//! Load your resources here
	function onLayout(dc) {
		font = Ui.loadResource(Rez.Fonts.master_of_36);
		//setLayout(Rez.Layouts.WatchFace(dc));
	}

	//! Called when this View is brought to the foreground. Restore
	//! the state of this View and prepare it to be shown. This includes
	//! loading resources into memory.
	function onShow() {
	}

	//! Update the view
	function onUpdate(dc) {
		theme = themes[App.getApp().getProperty("Theme")];
		//Sys.println("onUpdate, devs:" + App.getApp().getProperty("Theme") );
		//Sys.println("theme:" + theme );	
		dc.setColor(theme[2], theme[2]);
		dc.clear();

		// Call the parent onUpdate function to redraw the layout
		// View.onUpdate(dc);

		var time_str = makeClockTime();
		var time_ary = str2ary(time_str);
		//Sys.println("time_ary:" + time_ary + " \n");

		var now = Time.now();
		var info = Gregorian.info(now, Time.FORMAT_SHORT);
		//var info_m = Gregorian.info(now, Time.FORMAT_LONG).month; SHORT LONG

		//var dateStr = Lang.format("$1$:$2$:$3$", [info.day_of_week.toString().toUpper(), info.month.toString().toUpper(), info.day]);
		//dc.drawText(100, 120, font, dateStr, Gfx.TEXT_JUSTIFY_CENTER);
		var dow_ary = str2ary(mb_GetDayOfWeek(info.day_of_week));
		//var day_ary = str2ary(info.day.toString() + " " + info.month.toString().toUpper());
		var day_ary = str2ary(info.day.toString() + mb_GetMonth(info.month));
		var year_ary = str2ary(info.year.toString());

		//dc.setColor(0x6600CC, Gfx.COLOR_TRANSPARENT); // old
		//dc.setColor(0xAA00FF, Gfx.COLOR_TRANSPARENT); // new pink???
		dc.setColor(theme[0], Gfx.COLOR_TRANSPARENT);
		drawTextUp(dc, time_ary, stary_y);
		drawTextUp(dc, dow_ary, stary_y+42);
		//dc.setColor(0x555555, Gfx.COLOR_TRANSPARENT);
		dc.setColor(theme[1], Gfx.COLOR_TRANSPARENT);
		drawTextUp(dc, day_ary, stary_y+84);
		drawTextUp(dc, year_ary, stary_y+126);
	}

	//! Called when this View is removed from the screen. Save the
	//! state of this View here. This includes freeing resources from
	//! memory.
	function onHide() {
	}

	//! The user has just looked at their watch. Timers and animations may be started here.
	function onExitSleep() {
	}

	//! Terminate any active timers and prepare for slow updates.
	function onEnterSleep() {
	}

	hidden function drawTextUp(dc, ary, first_y) {
		var width, height;
		width = dc.getWidth();
		height = dc.getHeight();

		var tmp_x = 0;
		var org_x = (width - getBlockWidth(ary, dc))/2;
		var org_y = first_y;

		var n = ary.size();
		for(var i=0; i<n; i++) {
			var text_w = dc.getTextWidthInPixels(ary[i], font) + span;
			var x = org_x + tmp_x;
			var y = org_y - (x/10);
			//Sys.println("y: " + y);

			//Sys.print("getTextWidthInPixels " + time_ary[i] + ": " + dc.getTextWidthInPixels(time_ary[i], font) + ", x: " + x + "\n");
			dc.drawText(x, y , font, ary[i], Gfx.TEXT_JUSTIFY_LEFT);
			tmp_x += text_w;
		}
	}

	hidden function mb_GetMonth(num) {
		var str = "";
		if (num == 1) {
			str = "JAN";
		}
		else if (num == 2) {
			str = "FEB";
		}
		else if (num == 3) {
			str = "MAR";
		}
		else if (num == 4) {
			str = "APR";
		}
		else if (num == 5) {
			str = "MAY";
		}
		else if (num == 6) {
			str = "JUN";
		}
		else if (num == 7) {
			str = "JUL";
		}
		else if (num == 8) {
			str = "AUG";
		}
		else if (num == 9) {
			str = "SEP";
		}
		else if (num == 10) {
			str = "OCT";
		}
		else if (num == 11) {
			str = "NOV";
		}
		else if (num == 12) {
			str = "DEC";
		}
		return str;
	}

	hidden function mb_GetDayOfWeek(num) {
		var str = "";
		if (num == 1) {
			str = "SUN";
		}
		else if (num == 2) {
			str = "MON";
		}
		else if (num == 3) {
			str = "TUE";
		}
		else if (num == 4) {
			str = "WED";
		}
		else if (num == 5) {
			str = "THU";
		}
		else if (num == 6) {
			str = "FRI";
		}
		else if (num == 7) {
			str = "SAT";
		}
		return str;
	}

	hidden function getBlockWidth(ary, dc) {
		var w = 0;
		var n = ary.size();

		for(var i=0; i<n; i++) {
			w += dc.getTextWidthInPixels(ary[i], font);
		}
		w += (span * (n-1));
		//Sys.print("text_block_w: " + text_block_w + "\n");
		return w;
	}

	hidden function str2ary(str) {
		var str_count = str.length();
		var ary = new [str_count];

		for(var i=0; i<str_count; i++) {
			ary[i] = str.substring(i, i+1);
		}
		return ary;
	}

	//! Get the time from the clock and format it for
	//! the watch face
	hidden function makeClockTime() {
		var is24Hour = Sys.getDeviceSettings().is24Hour;
		//Sys.println("is24Hour:" + is24Hour);
		var clockTime = Sys.getClockTime();
		var hour = clockTime.hour;
		var min = clockTime.min;

		if (!is24Hour) {
			hour = clockTime.hour % 12;
		}
		return Lang.format("$1$:$2$",[hour, min.format("%02d")]);
	}
}

function getResolutionIndex(pixelDensity) {

    // images for different device densities are determined by the device's pixel density
    if (pixelDensity < 6.3)
        return 0; // mdpi
    else if (pixelDensity < 9.5)
        return 1; // hdpi
    else if (pixelDensity < 12.6)
        return 2; // xhdpi

    // anything larger use xxhdpi
    return 3;


}

function getScreenWidthIndex(width) {
    // width we use for images that want to be full screen width uses closest category
    if (width <= 400)
        return 0;
    else if (width <= 540)
        return 1;
    else if (width <= 812)
        return 2;
    else if (width <= 1152)
        return 3;
    else if (width <= 1600)
        return 4;
    else if (width <= 2240)
        return 5;
    else // any larger screen width uses the 2560 image width
        return 6;
}

/**
*
* Android Pixel Density Categories
* dpi and dots per mm, and standard multiplier for the size
*
* ldpi (low) ~120dpi (4.7 d/mm) x0.75
* mdpi (medium) ~160dpi (6.30 d/mm) x1
* hdpi (high) ~240dpi  (9.5 d/mm) x1.5
* xhdpi (extra-high) ~320dpi (12.6 d/mm) x2
* xxhdpi (extra-extra-high) ~480dpi (18.9 d/mm) x3
* xxxhdpi (extra-extra-extra-high) ~640dpi (25 d/mm) x4
*/

/**
* A typical Android item is 48dp high (translates to 9mm)
*
* ldpi: 36 (width: 320, 480)
* mdpi: 48 (width: 480, 600, 1024, 1280)
* hdpi: 72 (width: 1920)
* xhdpi: 96 (width: 2560)
*/

/**
* Android typical screen widths
*
* 320dp: a typical phone screen (240x320 ldpi, 320x480 mdpi, 480x800 hdpi, etc).
* 480dp: a tweener tablet like the Streak (480x800 mdpi).
* 600dp: a 7” tablet (600x1024 mdpi).
* 720dp: a 10” tablet (720x1280 mdpi, 800x1280 mdpi, etc).
*/

/*
*
* Android: typical screen sizes for different pixel density categories
*
* http://developer.android.com/guide/practices/screens_support.html#DeclaringTabletLayouts
* ldpi, mdpi: 320x480
* ldpi, mdpi, hdpi: ->480x800<-
* mdpi, hdpi: 600x1024
* mdpi: 1024x768 (1280x768, 1280x800)
* hdpi: 1920x1200 (1920x1152)
* xhdpi: 2560x1600 (2048x1536, 2560x1536)
*/

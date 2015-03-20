QMLGalaxyPortal
===============

A quick and easy way to check the status of biomedical research on Galaxy and review your history.

![](http://i955.photobucket.com/albums/ae34/Bornich/FeatureGraphic_zpsff509d03.png)

# Features

Browse your histories in a friendly format for small screen touch devices. Quickly see if a job is still running, has errors, is completed or a number of other possible statuses from colour coding, or by clicking on an item to flip it over and view status and other content data (data retrieved can be customised in the app settings).

Use the magnifier glass to zoom in and retrieve additional details and take a peek at the results, and zoom in even further to take a closer look at any data field.

## Colour Coding Chart

![](http://i955.photobucket.com/albums/ae34/Bornich/StatesColourCoding_zps01d0782c.png)

# Development

Developed at the Biomedicial Informatics research group at the Department of Informatics, University of Oslo. The app was developed in Qt (http://www.qt.io) using the QML language and JavaScript for cross-platform deployment. Access to Galaxy is done through the RESTful Galaxy API using JSON formatted data. This keeps bandwidth use low, and the polling frequency can be configured by the user in the settings.

There are many public and private Galaxy instances and being open-source a local instance can easily be deployed. In addition there are other services, such as the Hyperbrowser, which build upon the Galaxy platform and if these have a recent version of the Galaxy API enabled it is possible to also use the Galaxy Portal app to interface with these servers. To make it easier for researchers to use the app with multiple such Galaxy instances the app allows saving connection details to easily switch between sites.

The app is completely free and open source.

Qt (http://www.qt.io), a cross platform framework, has been used to develop an app that compiles to an OS native app, and provides a touch based interface that scales according to screen size and resolution. The Qt framework is C++ based, but the app was primarily developed using JavaScript and the Qt Modelling Language (QML). Compiling to a native Android and iOS app ensures that it performs optimally, while being able to implement the user interface and logic using QML and JavaScript allows for rapid development of a sophisticated and responsive interface using animations and platform native styling.
Access to Galaxy data is achieved using the RESTful Galaxy API to retrieve JSON formatted data which keeps bandwidth use low, and the polling frequency can be configured by the user. Interfacing to Galaxy through the API also means that the app can connect to any Galaxy site, or any tools built on top of the Galaxy source. 
Future versions of the app could be extended to allow jobs to be scheduled providing a more complete mobile interface for Galaxy.

# Documentation

See the user manual PDF in this repository: [GalaxyPortalUserGuide.pdf](https://github.com/Tarostar/QMLGalaxyPortal/blob/master/GalaxyPortalUserGuide.pdf?raw=true)

# Releases

The aim of the app is to be cross platform.

Binaries in various formats will generally be available in the [Releases](https://github.com/Tarostar/QMLGalaxyPortal/releases) section together with the corresponding source code for those who wish to compile it themselves. Please report any issues you discover.

* Windows binaries are provided as a zip file. Simply unzip and run QMLGalaxyPortal.exe
* Linux binaries are packed as a tar.gz and can be run by executing GalaxyPortal.sh (e.g. ./GalaxyPortal.sh which sets up a temporary LD_LIBRARY_PATH to load the correct libraries and modules. If you already have Qt 5.3 or later installed you can optionally just run QMLGalaxyPortal directly which will then link to the installed libraries and modules.
* Android apk is included, but will also be available on Google Play (currently in testing, contact for invite).
* iOS app (iPhone/iPad) is currently in closed testing, and a separate closed-source version based on a commercially licensed Qt version is planned for release through the Apple App Store.

A Mac and Windows Phone version is currently not planned, but may be added in future.

# Screenshots (on Android phone)

![](http://i955.photobucket.com/albums/ae34/Bornich/Screenshot_2014-10-28-13-23-28_zpsbca8ea27.png)

![](http://i955.photobucket.com/albums/ae34/Bornich/Screenshot_2014-10-28-13-23-41_zps07f0c2c8.png)

## Colour Coded Status

![](http://i955.photobucket.com/albums/ae34/Bornich/HistoryItems_JobQueued_short_zps4f99b0b5.png)

## Peek at your data

![](http://i955.photobucket.com/albums/ae34/Bornich/peek_zps21288ea7.png)

## Keep login details for multiple Galaxy instances

![](http://i955.photobucket.com/albums/ae34/Bornich/Screenshot_2015-01-10-11-15-02_zpse28af239.png)

# Build Instructions

## Windows

You will need to download Qt 5.3 or later (optionally with Qt Creator) on a Windows platform (Win 8.1 was used in testing). MinGW 4.8 was used, but similar compilers might work.

## Linux

Same as for windows, but you will need to perform the compilation on a Linux machine (Ubuntu was tested). g++ compiler from GCC (x86 64 bit) was used, but similar compilers might work.

## Android

An Android apk can be compiled on any platform where the Android SDK is supported (e.g. Windows or Linux). Apache-ant-1.9.3 together with android-ndk-r9c and adt bundle for windows was used in testing. Setting it up in Qt Creator is fairly easy as paths are simply set in Tools->Options under "Android" and you can run Android simulators directly in Qt Creator using the AVD Manager. You will also need a java developer kit, and jdk 1.7.0_45 was used. There are no special steps beyond the standard steps outlined by google for the Android SDK and by Qt for compiling Android apps.

## OSX (Mac) and iOS (iPhone/iPad)

As the iOS version is a separate non-GPL version and there is no release for Mac, full instructions are not included here. However, in either case Qt will need to be installed on a Mac together with XCode. Instructions are freely available online from the Qt website on how to use qmake to create a project that can be opened in XCode.


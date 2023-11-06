import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class AddLocation extends StatefulWidget {
  const AddLocation({Key? key}) : super(key: key);

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5
  );

  late GoogleMapController _googleMapController;
  Marker? _marker;
  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  void getTheLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_locationData.latitude!.toDouble(), _locationData.longitude!.toDouble()), zoom: 11.5),),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTheLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _googleMapController.dispose();
    super.dispose();
  }

  void _addMarker(LatLng latLng) {
    final marker = Marker(
      markerId: MarkerId(latLng.toString()),
      position: latLng,
    );
    setState(() {
      _marker = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFFEAFDFC),
        body: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) => _googleMapController = controller,
              onLongPress: (LatLng latLng) {
                _addMarker(latLng);
              },
              markers: _marker != null ? Set<Marker>.from([_marker!]) : Set<Marker>.identity(),
            ),
            Positioned(
                top: 40,
                left: 10,
                child: Container(
                  width: 280,
                  height: 50,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text("Long Press The Screen To Add Your Store Location",style: TextStyle(fontFamily: "ChalkBoldRe",fontSize: 11,color: Color(0xFF707070))),
                  ),
                ),
            ),
            Positioned(
                top: 40,
                left: 300,
                child: Container(
                  child: GestureDetector(
                    onTap: (){
                      if(_marker != null){
                        Navigator.pop(context,{'latitude': _marker!.position.latitude, 'longitude': _marker!.position.longitude});
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Shadow color
                              spreadRadius: 1, // Spread radius
                              blurRadius: 2, // Blur radius
                              offset: Offset(0, 3),
                            )
                          ],
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xFF91D8E4)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Save", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontFamily: 'Mr. Rockwell', color: Color(0xFF707070), fontWeight: FontWeight.bold,),),
                        ],
                      ),
                    ),
                  ),
                ),
            ),
          ]
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.black,
          onPressed: () {
            _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition),
            );
          },
          child: Icon(Icons.center_focus_strong),
        ),
      ),
    );
  }
}

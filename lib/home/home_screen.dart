import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:app/gremio/gremio_home.dart';
import 'package:app/inventario/inventario_home.dart';

class HomeScreen extends StatelessWidget {
  final List<dynamic>? healthDataList;
  final Function? fetchHealthData;
  final Function? authorize;
  final Function? checkHealthConnectAvailability;
  final dynamic appState;

  const HomeScreen({
    Key? key,
    this.healthDataList,
    this.fetchHealthData,
    this.authorize,
    this.checkHealthConnectAvailability,
    this.appState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // AppBar y TopBar
          Stack(
            children: [
Container(
            width: double.infinity,
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    'assets/Interfaz/HUDNotch.png',  // Replace with your image asset or network URL
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,      // Ensures the image maintains aspect ratio while scaling to width
                  ),
                ),
                SafeArea(
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return Stack(
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/Interfaz/HUDTop.png',  // Replace with your image asset or network URL
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fitWidth,      // Ensures the image maintains aspect ratio while scaling to width
                            ),
                          ),
                          Column(
                            children: [
                              Container(height: (MediaQuery.of(context).size.width)/131*6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  //PASOS
                                  Container(
                                    width: (MediaQuery.of(context).size.width)/131*50,
                                    height: (MediaQuery.of(context).size.width)/131*12,
                                    child: Row(
                                      children: [
                                        Container(width: (MediaQuery.of(context).size.width)/131*1),
                                        Image(
                                          image: const AssetImage('assets/Iconos/PHSteps.png'),
                                          width: (MediaQuery.of(context).size.width)/131*8,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        Container(width: (MediaQuery.of(context).size.width)/131*1),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          width: (MediaQuery.of(context).size.width)/131*40,
                                          child: Text(
                                              '99999',
                                              style: TextStyle(
                                                fontFamily: 'Jersey10',
                                                fontSize: (MediaQuery.of(context).size.width)/131*15,
                                                color: Colors.white,
                                                height: 0.5
                                              )
                                            ),
                                        )
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width: (MediaQuery.of(context).size.width)/131*11,
                                  ),

                                  //MONEDAS
                                  Container(
                                    width: (MediaQuery.of(context).size.width)/131*50,
                                    height: (MediaQuery.of(context).size.width)/131*12,
                                    child: Row(
                                      children: [
                                        Container(width: (MediaQuery.of(context).size.width)/131*1),
                                        Image(
                                          image: const AssetImage('assets/Iconos/PHCoin.png'),
                                          width: (MediaQuery.of(context).size.width)/131*8,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        Container(width: (MediaQuery.of(context).size.width)/131*1),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          width: (MediaQuery.of(context).size.width)/131*40,
                                          child: Text(
                                              '99999',
                                              style: TextStyle(
                                                fontFamily: 'Jersey10',
                                                fontSize: (MediaQuery.of(context).size.width)/131*15,
                                                color: Colors.white,
                                                height: 0.5
                                              )
                                            ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      );
                    }
                  ),
                ),
              ],
            )
          ),
            ],
          ),
          // Main content
          Expanded(
            child: Center(
              child: appState == AppState.DATA_READY
                  ? ListView.builder(
                      itemCount: healthDataList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text("Data point $index"),
                        );
                      },
                    )
                  : Text("No data fetched"),
            ),
          ),
          // Bottom navigation bar
          Stack(
            children: [
              Container(
                width: double.infinity,
                child: Center(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/Interfaz/HUDNotch.png',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          navigationButton(context, 'assets/Interfaz/HUDBottom1ALT.png', InventarioHome()),
                          SizedBox(width: MediaQuery.of(context).size.width / 131 * 18),
                          navigationButton(context, 'assets/Interfaz/HUDBottom2.png', HomeScreen()),
                          SizedBox(width: MediaQuery.of(context).size.width / 131 * 18),
                          navigationButton(context, 'assets/Interfaz/HUDBottom3ALT.png', GremioHome()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHealthInfo(BuildContext context, String iconPath, String value) {
    return Container(
      width: MediaQuery.of(context).size.width / 131 * 50,
      child: Row(
        children: [
          Image.asset(iconPath, width: MediaQuery.of(context).size.width / 131 * 8),
          SizedBox(width: MediaQuery.of(context).size.width / 131 * 1),
          Text(value, style: TextStyle(fontSize: 20, color: Colors.white)),
        ],
      ),
    );
  }

  Widget navigationButton(BuildContext context, String imagePath, Widget destination) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => destination)),
      child: Image.asset(imagePath, width: MediaQuery.of(context).size.width / 131 * 23),
    );
  }
}

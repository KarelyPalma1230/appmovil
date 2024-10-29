import 'dart:async';
import 'dart:io';

import 'package:app/gremio/gremio_home.dart';
import 'package:app/home/home_screen.dart';
import 'package:app/inventario/inventario_home.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quita el banner de debug si es necesario
      title: 'Health App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HealthApp(),
    );
  }
}

class HealthApp extends StatefulWidget {
  @override
  _HealthAppState createState() => _HealthAppState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_DELETED,
  DATA_NOT_ADDED,
  DATA_NOT_DELETED,
  STEPS_READY,
  HEALTH_CONNECT_STATUS,
  PERMISSIONS_REVOKING,
  PERMISSIONS_REVOKED,
  PERMISSIONS_NOT_REVOKED,
}

class _HealthAppState extends State<HealthApp> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  int _nofSteps = 0;
  List<RecordingMethod> recordingMethodsToFilter = [];

  // Health data types for Android and iOS
  final List<HealthDataType> dataTypesAndroid = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.WEIGHT,
  ];

  final List<HealthDataType> dataTypesIOS = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.WEIGHT,
  ];

  List<HealthDataType> get types =>
      Platform.isAndroid ? dataTypesAndroid : dataTypesIOS;

  List<HealthDataAccess> get permissions => types
      .map((type) => [
            HealthDataType.WALKING_HEART_RATE,
            HealthDataType.ELECTROCARDIOGRAM,
            HealthDataType.HIGH_HEART_RATE_EVENT,
            HealthDataType.LOW_HEART_RATE_EVENT,
            HealthDataType.IRREGULAR_HEART_RATE_EVENT,
            HealthDataType.EXERCISE_TIME,
          ].contains(type)
              ? HealthDataAccess.READ
              : HealthDataAccess.READ_WRITE)
      .toList();

  @override
  void initState() {
    super.initState();
    Health().configure();
    checkHealthConnectAvailability();
  }

  Future<void> checkHealthConnectAvailability() async {
    if (Platform.isAndroid) {
      final status = await Health().getHealthConnectSdkStatus();
      setState(() {
        _state = AppState.HEALTH_CONNECT_STATUS;
      });
    }
  }

  Future<void> authorize() async {
    await Permission.activityRecognition.request();
    await Permission.location.request();

    bool? hasPermissions =
        await Health().hasPermissions(types, permissions: permissions);

    if (hasPermissions == null || !hasPermissions) {
      try {
        bool authorized = await Health()
            .requestAuthorization(types, permissions: permissions);
        setState(() => _state =
            authorized ? AppState.AUTHORIZED : AppState.AUTH_NOT_GRANTED);
      } catch (error) {
        debugPrint("Exception in authorize: $error");
      }
    } else {
      setState(() => _state = AppState.AUTHORIZED);
    }
  }

  Future<void> fetchData() async {
    setState(() => _state = AppState.FETCHING_DATA);
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));

    try {
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: types,
        startTime: yesterday,
        endTime: now,
        recordingMethodsToFilter: recordingMethodsToFilter,
      );
      _healthDataList = Health().removeDuplicates(healthData);
      setState(() => _state =
          _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY);
    } catch (error) {
      debugPrint("Exception in fetchData: $error");
      setState(() => _state = AppState.NO_DATA);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      healthDataList: _healthDataList,
      fetchHealthData: fetchData,
      authorize: authorize,
      checkHealthConnectAvailability: checkHealthConnectAvailability,
      appState: _state,
    );
  }
}

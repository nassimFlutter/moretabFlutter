import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Data Recorder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DeviceDataRecorder(),
    );
  }
}

class DeviceDataRecorder extends StatefulWidget {
  @override
  _DeviceDataRecorderState createState() => _DeviceDataRecorderState();
}

class _DeviceDataRecorderState extends State<DeviceDataRecorder>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Tab> myTabs = [];
  List<Widget> myTabViews = [];
  int _lastSelectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 0);
    _loadLastSelectedTab();
  }

  Future<void> _loadLastSelectedTab() async {
    // This is where you would load the last selected tab index from storage.
    // For simplicity, it's set to 0 in this example.
    setState(() {
      _lastSelectedTabIndex = 0;
      _tabController = TabController(
          vsync: this,
          length: myTabs.length,
          initialIndex: _lastSelectedTabIndex);
    });
  }

  void _addNewDeviceTab() {
    setState(() {
      myTabs.add(
        Tab(
          child: Row(
            children: [
              Text('Device ${myTabs.length + 1}'),
              IconButton(
                icon: Icon(Icons.cancel, size: 18),
                onPressed: () => _removeDeviceTab(_tabController.index),
              ),
            ],
          ),
        ),
      );
      myTabViews.add(DeviceDataInput());
      _tabController.dispose();
      _tabController = TabController(
        vsync: this,
        length: myTabs.length,
      );
      _tabController.animateTo(myTabs.length - 1);
    });
  }

  void _removeDeviceTab(int index) {
    print(index);
    setState(() {
      myTabs.removeAt(index);
      myTabViews.removeAt(index);

      // Update _lastSelectedTabIndex to be within bounds
      _lastSelectedTabIndex = _tabController.index;
      if (_lastSelectedTabIndex >= myTabs.length) {
        _lastSelectedTabIndex = myTabs.length - 1;
      }

      _tabController.dispose();
      _tabController = TabController(
        vsync: this,
        length: myTabs.length,
        initialIndex: _lastSelectedTabIndex,
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Data Recorder'),
        bottom: myTabs.isNotEmpty
            ? TabBar(
                controller: _tabController,
                tabs: myTabs,
              )
            : null,
      ),
      body: myTabs.isNotEmpty
          ? TabBarView(
              controller: _tabController,
              children: myTabViews,
            )
          : Center(child: Text('No devices added.')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewDeviceTab,
        child: Icon(Icons.add),
      ),
    );
  }
}

class DeviceDataInput extends StatefulWidget {
  @override
  _DeviceDataInputState createState() => _DeviceDataInputState();
}

class _DeviceDataInputState extends State<DeviceDataInput> {
  final TextEditingController voltageController = TextEditingController();
  final TextEditingController currentController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: voltageController,
            decoration: InputDecoration(
              labelText: 'Voltage (V)',
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: currentController,
            decoration: InputDecoration(
              labelText: 'Current (A)',
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: frequencyController,
            decoration: InputDecoration(
              labelText: 'Frequency (Hz)',
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Save data or perform necessary actions
              print('Voltage: ${voltageController.text}');
              print('Current: ${currentController.text}');
              print('Frequency: ${frequencyController.text}');
            },
            child: Text('Save Data'),
          ),
        ],
      ),
    );
  }
}

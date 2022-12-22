import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:hive/hive.dart';
// import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter DropDownButton',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// Initial Selected Value
  String dropdownvalue = 'Select Department';

// List of items in our dropdown menu
  List<String> department = [
    'Select Department',
    'Android',
    'Ios',
    'web',
  ];
  var employee = [];
  final box = GetStorage();

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    // employee = await box.read('empl');
  }

  @override
  Widget build(BuildContext context) {
    final depa = box.read('dep');
    if (depa != null) {
      department = List<String>.from(depa);
    }

    var emplo = box.read('empl');
    if (emplo != null) {
      employee = emplo;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Department Manage"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: employee.length,
                  itemBuilder: ((context, index) {
                    return employee.isEmpty
                        ? Container()
                        : Column(
                            children: [
                              Container(
                                color: Colors.grey.shade200,
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                          employee[index]['department'] ?? ''),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            employee[index]['employees'].add({
                                              "fieldName": "Email Id",
                                              "validate": "none",
                                              "onField": true,
                                            });
                                          });
                                          await box
                                              .write('efield',
                                                  employee[index]['employees'])
                                              .then((value) async {});
                                        },
                                        icon: const Icon(Icons.add))
                                  ],
                                ),
                              ),
                              employee[index]['employees'].isEmpty
                                  ? Container()
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          employee[index]['employees'].length,
                                      itemBuilder: ((context, i) {
                                        var depa = box.read('efield');
                                        if (depa != null) {
                                          employee[index]['employees'] = depa;
                                        }
                                        var empl =
                                            employee[index]['employees'][i];
                                        return Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    onChanged: (value) {
                                                      setState(() {
                                                        if (value.isNotEmpty) {
                                                          empl['validate'] =
                                                              "true";
                                                        } else {
                                                          empl['validate'] =
                                                              "false";
                                                        }
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          "${empl['fieldName']} ${i + 1}",
                                                      errorText: empl[
                                                                  'validate'] ==
                                                              "false"
                                                          ? "Enter Valid Email${i + 1}"
                                                          : null,
                                                      suffixIcon: Column(
                                                        children: [
                                                          Switch(
                                                              activeColor:
                                                                  Colors.amber,
                                                              activeTrackColor:
                                                                  Colors.grey
                                                                      .shade300,
                                                              inactiveThumbColor:
                                                                  Colors
                                                                      .blueGrey
                                                                      .shade600,
                                                              inactiveTrackColor:
                                                                  Colors.grey
                                                                      .shade400,
                                                              splashRadius:
                                                                  50.0,
                                                              value: empl[
                                                                  'onField'],
                                                              onChanged:
                                                                  (value) async {
                                                                setState(() {
                                                                  empl['onField'] =
                                                                      value;
                                                                });
                                                                // await box
                                                                //     .write(
                                                                //         'efield',
                                                                //         employee[index]
                                                                //             [
                                                                //             'employees'])
                                                                //     .then(
                                                                //         (value) async {
                                                                //   // employee = await box.read('empl');
                                                                // });

                                                                ///remove
                                                                // int checkOn = employee[
                                                                //             index]
                                                                //         [
                                                                //         'employees']
                                                                //     .where((item) =>
                                                                //         item[
                                                                //             'onField'] ==
                                                                //         true)
                                                                //     .length;
                                                                // if (checkOn <=
                                                                //     0) {
                                                                //   // employee[
                                                                //   //         index]
                                                                //   //     [
                                                                //   //     'employees'] = [];

                                                                //   await box
                                                                //       .write(
                                                                //           'efield',
                                                                //           employee[index]
                                                                //               [
                                                                //               'employees'])
                                                                //       .then(
                                                                //           (value) async {
                                                                //     // employee = await box.read('empl');
                                                                //   });
                                                                // }
                                                              }),
                                                        ],
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          Colors.grey.shade100,
                                                      border:
                                                          const OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      })),
                            ],
                          );
                  })),
              DropdownButton(
                value: dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: department.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) async {
                  setState(() {
                    if (newValue != "Select Department") {
                      employee.add({"department": newValue, "employees": []});

                      department.remove(newValue);
                    }
                  });
                  await box.write('dep', department).then((value) async {});
                  await box.write('empl', employee).then((value) async {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

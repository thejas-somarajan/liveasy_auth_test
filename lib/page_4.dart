import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  int _selectedProfile = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 100,),
                const Text(
                  'Please select your profile',
                  style: TextStyle(
                   fontSize: 24,
                   fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 50,),
                Container(
                  padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                      )
                    ),
                  child: RadioListTile<int>(
                      title: const Row(
                        children: [
                          Icon(Icons.warehouse_outlined, size: 60),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Shipper', style: TextStyle(fontSize: 25)),
                              Text(
                                'Lorem ipsum dolor sit amet,\nconsectetur adipiscing',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                      value: 0,
                      groupValue: _selectedProfile,
                      onChanged: (value) => setState(() => _selectedProfile = value!),
                    ),
                ),
                  const SizedBox(height: 50,),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                      )
                    ),
                    child: RadioListTile<int>(
                      title: const Row(
                        children: [
                          Icon(Icons.fire_truck_outlined, size: 60),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Transporter', style: TextStyle(fontSize: 25)),
                              Text(
                                'Lorem ipsum dolor sit amet,\nconsectetur adipiscing',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                      value: 1,
                      groupValue: _selectedProfile,
                      onChanged: (value) => setState(() => _selectedProfile = value!),
                    ),
                  ),
                  const SizedBox(height: 50,),
                  Container(
                    height: 70,
                    width: 500,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const ProfilePage()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 23, 46, 85)),
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ), 
                        child: const Text(
                          'CONTINUE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                                     ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
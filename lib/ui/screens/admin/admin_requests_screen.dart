import 'package:dinte_albastru/model/registration_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../navigator.dart';
import '../../../view_model/registration_view_model.dart';
import '../../widgets/custom_expansion_tile.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreen();
}

class _RequestsScreen extends State<RequestsScreen> with ChangeNotifier {
  List<RegistrationRequest> requests = List.empty();

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    final viewModel = context.read<RegistrationViewModel>();
    final List<RegistrationRequestEntity> registrationRequests =
        await viewModel.fetchRegistrationRequests();
    setState(() {
      requests =
          registrationRequests.map((request) => request.toModel).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<RegistrationViewModel>();
    final registrationRequests = viewModel.requests;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/drawables/chairman.png', fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child:
                      registrationRequests.isEmpty
                          ? const Center(
                            child: Text(
                              "There are no new requests",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                          : ListView.builder(
                            itemBuilder: (context, index) {
                              final request = registrationRequests[index];

                              return CustomExpansionTile(
                                title: request.fullName,
                                children: [
                                  ListTile(
                                    title: Text(
                                      "Position: ${request.position}\n Admin: ${request.isAdmin}",
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.verified,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete_forever,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    "Confirm rejection",
                                                  ),
                                                  actions: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        navigateBack(context);
                                                      },
                                                      child: Text(
                                                        "Decline",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),

                                                    GestureDetector(
                                                      onTap: () async {
                                                        navigateBack(context);
                                                        await viewModel
                                                            .deleteRegistrationRequest(
                                                              request.fullName,
                                                            );
                                                        fetchRequests();
                                                      },
                                                      child: Text(
                                                        'Confirm',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                            itemCount: registrationRequests.length,
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

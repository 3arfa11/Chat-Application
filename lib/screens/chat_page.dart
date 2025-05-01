import 'package:chat_application/helpers/constants.dart';
import 'package:chat_application/models/message_model.dart';
import 'package:chat_application/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key, required this.email});
  String email;
  TextEditingController controller = TextEditingController();
  CollectionReference messages =
      FirebaseFirestore.instance.collection(messagesCollection);
  final _listController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy(sentAtTime, descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MessageModel> messagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(MessageModel.fromJson(snapshot.data!.docs[i]));
            }
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: primaryColor,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        appLogo,
                        width: 60,
                      ),
                      Text(
                        "Chat",
                        style: TextStyle(
                            color: Colors.white, fontFamily: "Pacifico"),
                      )
                    ],
                  ),
                  actions: [
                    PopupMenuButton(
                        onSelected: (item) => handleClick(item),
                        icon: Icon(
                          CupertinoIcons.ellipsis_vertical,
                          color: Colors.white,
                        ),
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                  onTap: () async {
                                    await FirebaseAuth.instance.signOut();
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  value: 0,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Logout',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.logout_rounded,
                                        color: Colors.black,
                                      )
                                    ],
                                  ))
                            ])
                  ],
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          reverse: true,
                          controller: _listController,
                          itemCount: messagesList.length,
                          itemBuilder: (context, index) {
                            return messagesList[index].email == email
                                ? ChatBubble(
                                    message: messagesList[index],
                                  )
                                : IncomingChatBubble(
                                    message: messagesList[index]);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: controller,
                        onSubmitted: (data) {
                          if (controller.text != "") {
                            messages.add({
                              messageDocument: data,
                              sentAtTime: DateTime.now(),
                              'email': email
                            });
                            controller.clear();
                            _listController.animateTo(
                              0,
                              duration: Duration(seconds: 2),
                              curve: Curves.fastOutSlowIn,
                            );
                          } else {
                            return;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Send a message",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                if (controller.text != "") {
                                  messages.add({
                                    messageDocument: controller.text,
                                    sentAtTime: DateTime.now(),
                                    'email': email
                                  });
                                  controller.clear();
                                  _listController.animateTo(
                                    0,
                                    duration: Duration(seconds: 2),
                                    curve: Curves.fastOutSlowIn,
                                  );
                                } else {
                                  return;
                                }
                              },
                              child: Icon(
                                Icons.send,
                                color: primaryColor,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.red.withValues(alpha: 1))),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.red.withValues(alpha: .8))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.blue.withValues(alpha: .8))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey))),
                      ),
                    )
                  ],
                ));
          } else {
            return Text("Loading");
          }
        });
  }
}

void handleClick(int item) {
  switch (item) {
    case 0:
      break;
    case 1:
      break;
  }
}

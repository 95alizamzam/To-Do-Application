import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'package:to_do_app/modules/home_page.dart';
import 'package:to_do_app/shared/components/functions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class contact_us extends StatelessWidget {
  contact_us({Key? key}) : super(key: key);

  List<Map<String, dynamic>> contact = [
    {
      'method': 'via phone number',
      'icon': FaIcon(
        FontAwesomeIcons.phone,
        color: Colors.blue,
      ),
      'color': Colors.blue,
    },
    {
      'method': 'via SMS',
      'icon': FaIcon(
        FontAwesomeIcons.sms,
        color: Colors.yellow,
      ),
      'color': Colors.yellow,
    },
    {
      'method': 'via whatsApp',
      'icon': FaIcon(
        FontAwesomeIcons.whatsapp,
        color: Colors.green,
      ),
      'color': Colors.green,
    },
    {
      'method': 'via LinkedIn',
      'icon': FaIcon(
        FontAwesomeIcons.linkedin,
        color: Colors.cyan,
      ),
      'color': Colors.cyan,
    },
    {
      'method': 'via Email',
      'icon': Icon(
        Icons.email_rounded,
        color: Colors.red,
      ),
      'color': Colors.red,
    },
    {
      'method': 'via Facebook',
      'icon': FaIcon(
        FontAwesomeIcons.facebook,
        color: Colors.blueGrey,
      ),
      'color': Colors.blueGrey,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'TODO Application',
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          leading: IconButton(
              onPressed: () {
                goto(
                  goalScreen: homePage(),
                  context: context,
                  moveType: PageTransitionType.fade,
                );
              },
              icon: Icon(
                Icons.home,
                size: 30,
                color: Colors.red.shade400,
              )),
          actions: [
            Container(
              width: 40,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Image(image: AssetImage('images/icon.png')),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(),
                child: ClipRRect(
                  child: Image(
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 5,
                    image: AssetImage('images/contact_us.jpg'),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'Contact us : ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, index) => contactItem(
                  number: (index + 1).toString(),
                  title: contact[index]['method'],
                  trailingWidget: contact[index]['icon'],
                  color: contact[index]['color'],
                  context: context,
                ),
                itemCount: contact.length,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

Widget contactItem({
  required String number,
  required String title,
  required Widget trailingWidget,
  required Color color,
  required BuildContext context,
}) {
  return Container(
    padding: const EdgeInsets.all(6),
    child: Row(
      children: [
        CircleAvatar(
          radius: 25,
          child: Text(
            number,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: color,
        ),
        const SizedBox(width: 10),
        Expanded(
            child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        )),
        GestureDetector(
            onTap: () {
              if (number == '1') {
                phoneNumberContact();
              } else if (number == '2') {
                smsContact();
              } else if (number == '3') {
                whatsAppContact(context: context);
              } else if (number == '4') {
                linkedInContact(context: context);
              } else if (number == '5') {
                emailContact(
                  context: context,
                );
              } else {
                facebookContact(context: context);
              }
            },
            child: trailingWidget),
      ],
    ),
  );
}

void phoneNumberContact() {
  launch('tel://${009647515477206}');
}

void smsContact() {
  launch('sms:${009647515477206}');
}

void facebookContact({
  required BuildContext context,
}) async {
  await canLaunch('https://www.facebook.com/ali.zamzam.92798')
      ? await launch('https://www.facebook.com/ali.zamzam.92798')
      : Toast.show(
          'Cant open Facebook right Now',
          context,
          backgroundColor: Colors.red,
          duration: 2,
          backgroundRadius: 30,
        );
}

void linkedInContact({
  required BuildContext context,
}) async {
  await canLaunch('https://www.linkedin.com/in/ali-zamzam-361193207/')
      ? await launch('https://www.linkedin.com/in/ali-zamzam-361193207/')
      : Toast.show(
          'No Internet Connection',
          context,
          backgroundColor: Colors.red,
          duration: 2,
          backgroundRadius: 30,
        );
}

void whatsAppContact({
  required BuildContext context,
}) async {
  final String url = 'whatsapp://send?phone=${009647515477207}&&text=' '';
  await canLaunch(url)
      ? launch(url)
      : Toast.show(
          'Cant open whatsApp right Now',
          context,
          backgroundColor: Colors.red,
          backgroundRadius: 30,
          duration: 1,
        );
}

void emailContact({
  required BuildContext context,
}) {
  final alertDialog = AlertDialog(
    title: Text('Contact via Email'),
    content: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            color: Colors.red,
            indent: 0,
            endIndent: 20,
          ),
          Text('Do you Want sending email for TODO app Developer?!')
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () async {
          final String myEmail =
              'mailto:alizamzamacc@gmail.com?subject=' '&body=' '';
          await canLaunch(myEmail)
              ? launch(myEmail).then((value) {
                  Navigator.of(context).pop();
                })
              : Toast.show(
                  'No Internet Connection',
                  context,
                  backgroundColor: Colors.red,
                  duration: 2,
                  backgroundRadius: 30,
                );
        },
        child: Text(
          'Send',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'Cancel',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ],
  );
  showDialog(
      context: context,
      builder: (_) {
        return alertDialog;
      });
}

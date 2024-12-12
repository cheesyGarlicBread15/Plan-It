import 'package:flutter/material.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam libero dui, blandit sed est in, tincidunt eleifend orci. Morbi sit amet aliquam sem, quis aliquam dolor. Etiam aliquam, metus sit amet congue maximus, odio ipsum eleifend felis, ut euismod arcu ex ut diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Etiam hendrerit maximus eros a convallis. Sed a dolor orci. Aenean vehicula sodales sollicitudin. Maecenas egestas porttitor fringilla. Cras convallis tempus mollis. Praesent euismod consectetur massa id dictum. Vestibulum malesuada tellus non arcu eleifend fermentum. Ut congue luctus lacus, sit amet luctus mauris facilisis nec. Pellentesque nec laoreet metus. Proin imperdiet libero id justo tempus egestas vestibulum a nisi. Vestibulum ac hendrerit neque, ut vulputate odio."),
    );
  }
}
class UserChat {
  String content;
  String idFrom;
  String idTo;
  String timeStamp;

  UserChat(
      {required this.content,
      required this.idFrom,
      required this.idTo,
      required this.timeStamp});
}

class name extends StatefulWidget {
  const name({super.key});

  @override
  State<name> createState() => _nameState();
}

class _nameState extends State<name> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

StreamBuilder(
  stream: stream,
  initialData: initialData,
  builder: (BuildContext context, AsyncSnapshot snapshot) {
    return Container(
      child: child,
    );
  },
),
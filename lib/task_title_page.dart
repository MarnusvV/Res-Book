import 'dart:math';
import 'package:flutter/material.dart';
import 'widgets/tasks_list.dart';
import 'widgets/add_task_screen.dart';
import 'models/task_data.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ResipePage extends StatefulWidget {
  @override
  State<ResipePage> createState() => _ResipePageState();
}

class _ResipePageState extends State<ResipePage>
    with SingleTickerProviderStateMixin {
  Animation? animation;
  AnimationController? controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = ColorTween(begin: Colors.white, end: Color(0xffff7b42))
        .animate(controller!);
    controller!.forward();
    controller!.addListener(
      () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  List<Widget> recipeButtonsList = <Widget>[];

  void createNewButtonFromText(String inputText) {
    setState(() {
      recipeButtonsList.add(Dismissible(
        background: Container(
          color: Colors.red,
        ),
        key: Key('$newRecipeTitle' + Random().nextDouble().toString()),
        child: MaterialButton(
            onPressed: () {
              Navigator.push(context, $newRecipeTitle());
            },
            child: Text(inputText)),
      ));
    });
  }

  String? newRecipeTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation!.value,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffff7b42),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                      child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      color: Color(0xFF757575),
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Add Recipe',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                              ),
                            ),
                            TextField(
                              autofocus: true,
                              textAlign: TextAlign.center,
                              onChanged: (newText) {
                                newRecipeTitle = newText;
                              },
                            ),
                            TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xffff7b42))),
                              onPressed: () {
                                createNewButtonFromText('$newRecipeTitle');
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )));
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(
                30.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Image.asset('images/chef-hat.webp'),
                    height: 120.0,
                  ),
                  Text(
                    'Recipe List',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 50.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 800.0,
                    ),
                    ...recipeButtonsList
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class $newRecipeTitle extends MaterialPageRoute<Null> {
  File? _image;

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      this._image = imageTemporary;
    });
  }

  $newRecipeTitle()
      : super(builder: (BuildContext ctx) {
          return Scaffold(
            backgroundColor: Colors.teal,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.teal,
              onPressed: () {
                showModalBottomSheet(
                  context: ctx,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddTaskScreen(),
                    ),
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: 40.0, left: 30.0, right: 20.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30.0,
                        child: Image.asset('images/chef-hat.webp'),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Recipe list',
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        '${Provider.of<TaskData>(ctx).taskCount} Todos',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: TasksList(),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
}

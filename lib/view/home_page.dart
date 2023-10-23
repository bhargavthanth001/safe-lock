import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_lock/model/album_model.dart';
import 'package:safe_lock/utils.dart';
import 'package:safe_lock/view/create_page.dart';
import 'package:safe_lock/view/setting.dart';
import 'package:safe_lock/view/image_viewer.dart';
import 'package:safe_lock/view/lock_screen.dart';
import '../data_handler/data_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("HomePage"),
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FutureBuilder<List<AlbumModel>?>(
                  future: DataHandler.getAlbums(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error : ${snapshot.error.toString()}'));
                    } else if (snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.folder_off_outlined,
                              size: 30,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'No albums found',
                              style: TextStyle(
                                color: Colors.blue.shade400,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      final responseData = snapshot.data!;
                      return GridView.count(
                        crossAxisCount: 2,
                        children: List.generate(
                          responseData.length,
                          (index) {
                            debugPrint(responseData[index].password);
                            return GestureDetector(
                              onTap: () async {
                                Utils.shared.isLockScreen = true;
                                Utils.shared.isInactive = true;
                                Utils.shared.widget = ImageView(
                                  model: responseData[index],
                                );
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => responseData[index]
                                                .password !=
                                            null
                                        ? LockScreen(
                                            model: responseData[index],
                                            lock: false,
                                          )
                                        : ImageView(model: responseData[index]),
                                  ),
                                );
                                if (result != null) {
                                  setState(() {});
                                }
                              },
                              onLongPress: () {
                                Utils.shared.isLockScreen = true;
                                Utils.shared.isInactive = true;
                                Utils.shared.widget = SettingPage(
                                    albumModel: responseData[index]);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingPage(
                                      albumModel: responseData[index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: responseData[index].images.isEmpty
                                      ? const DecorationImage(
                                          image: AssetImage(
                                              "assets/images/placeholder.png"))
                                      : DecorationImage(
                                          image: FileImage(
                                            File(
                                              responseData[index].images.last,
                                            ),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 30,
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5)),
                                        color: Colors.black.withOpacity(0.7)),
                                    child: Center(
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        responseData[index].title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Utils.shared.widget = const AddAlbum();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAlbum(),
            ),
          );
        },
        materialTapTargetSize: MaterialTapTargetSize.padded,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

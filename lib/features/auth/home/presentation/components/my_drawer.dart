import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimedai/features/auth/home/presentation/components/my_drawer_tile.dart';
import 'package:nutrimedai/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:nutrimedai/features/profile/presentation/pages/profile_page.dart';
import 'package:nutrimedai/features/food_scanner/presentation/pages/food_scanner_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              // app logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.restaurant_menu,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              Divider(color: Theme.of(context).colorScheme.secondary),

              //home list tile
              MyDrawerTile(
                title: "H O M E ",
                icon: Icons.home,
                onTap: () => Navigator.of(context).pop(),
              ),

              //Scanner tile
              MyDrawerTile(
                title: "E S C A N E A R",
                icon: Icons.camera_alt,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FoodScannerPage(),
                    ),
                  );
                },
              ),

              //Profile tile
              MyDrawerTile(
                title: "P R O F I L E ",
                icon: Icons.person,
                onTap: () {
                  //  pop menu drawer
                  Navigator.pop(context);

                  // get current user id
                  final user = context.read<AuthCubit>().currentUser;
                  String? uid = user!.uid;

                  //  navigate to profile page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(uid: uid),
                    ),
                  );
                },
              ),

              //SETTINGS tile
              MyDrawerTile(
                title: "S E T T I N G S",
                icon: Icons.settings,
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              const Spacer(),

              // logout list tile
              MyDrawerTile(
                title: "L O G O U T",
                icon: Icons.logout,
                onTap: () => context.read<AuthCubit>().logout(),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

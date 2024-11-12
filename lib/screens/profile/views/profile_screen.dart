import 'package:bookstore/screens/profile/views/components/profile_card.dart';
import 'package:bookstore/screens/profile/views/components/profile_menu_item_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bookstore/components/list_tile/divider_list_tile.dart';
import 'package:bookstore/components/network_image_with_loader.dart';
import 'package:bookstore/constants.dart';
import 'package:bookstore/route/screen_export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // Get current Firebase user
    final googleUser = GoogleSignIn().currentUser; // Get Google SignIn user

    String name = 'Guest';
    String email = '';
    String imageUrl = ''; // Default image for guest

    if (user != null) {
      // If the user is signed in with Firebase (Anonymous or Google)
      if (googleUser != null) {
        // If logged in with Google
        name = googleUser.displayName ?? 'Google User';
        email = googleUser.email;
        imageUrl = googleUser.photoUrl ?? ''; // Use Google profile image
      } else if (user.isAnonymous) {
        // If logged in as guest (Anonymous user)
        name = 'Guest';
        email = 'guest@example.com'; // Default guest email
        imageUrl = ''; // Add a guest image
      } else {
        // If logged in via Firebase Auth (other than anonymous or Google)
        name = user.displayName ?? 'User';
        email = user.email ?? 'No Email';
        imageUrl = user.photoURL ?? ''; // Use Firebase user photo URL if available
      }
    }

    return Scaffold(
      body: ListView(
        children: [
          ProfileCard(
            name: name,
            email: email,
            imageSrc: imageUrl.isNotEmpty
                ? imageUrl
                : 'https://e7.pngegg.com/pngimages/518/320/png-clipart-computer-icons-mobile-app-development-android-my-account-icon-blue-text.png', // Default image for guest
            press: () {
              Navigator.pushNamed(context, userInfoScreenRoute);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(
              "Account",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ProfileMenuListTile(
            text: "Orders",
            svgSrc: "assets/icons/Order.svg",
            press: () {
              Navigator.pushNamed(context, ordersScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Saved",
            svgSrc: "assets/icons/Wishlist.svg",
            press: () {},
          ),
          const SizedBox(height: defaultPadding),
          ProfileMenuListTile(
            text: "Preferences",
            svgSrc: "assets/icons/Preferences.svg",
            press: () {
              Navigator.pushNamed(context, preferencesScreenRoute);
            },
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Text(
              "Help & Support",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ProfileMenuListTile(
            text: "Get Help",
            svgSrc: "assets/icons/Help.svg",
            press: () {
              Navigator.pushNamed(context, getHelpScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "FAQ",
            svgSrc: "assets/icons/FAQ.svg",
            press: () {},
            isShowDivider: false,
          ),
          const SizedBox(height: defaultPadding),
          // Log Out
          ListTile(
            onTap: () async {
              // Sign out based on the user type (Google or Anonymous)
              if (googleUser != null) {
                // Google Sign-Out
                await GoogleSignIn().signOut();
              } else {
                // Firebase Anonymous Sign-Out
                await FirebaseAuth.instance.signOut();
              }

              // Clear login status from SharedPreferences
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false); // Reset login status

              // Navigate to Login screen and clear the navigation stack
              Navigator.pushNamedAndRemoveUntil(
                context,
                logInScreenRoute, // The login screen route
                (route) => false, // Remove all previous routes
              );
            },
            minLeadingWidth: 24,
            leading: SvgPicture.asset(
              "assets/icons/Logout.svg",
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(
                errorColor,
                BlendMode.srcIn,
              ),
            ),
            title: const Text(
              "Log Out",
              style: TextStyle(color: errorColor, fontSize: 14, height: 1),
            ),
          )
        ],
      ),
    );
  }
}

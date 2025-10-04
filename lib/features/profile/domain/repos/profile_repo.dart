/*

Profile Repository

*/

import 'package:nutrimedai/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchUserProfile(String uid);
  Future<void> updateProfile(ProfileUser updatedProfille);
  Future<void> toggleFollow(String currentUid, String targetUid);
}

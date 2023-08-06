// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;
  final String name;
  final String profilePic;
  final String banner;
  // if guest, then isAuthenticated is false
  final bool isAuthenticated;
  final int karms;
  final List<String> awards;
  UserModel({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.banner,
    required this.isAuthenticated,
    required this.karms,
    required this.awards,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? profilePic,
    String? banner,
    bool? isAuthenticated,
    int? karms,
    List<String>? awards,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      banner: banner ?? this.banner,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      karms: karms ?? this.karms,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profilePic': profilePic,
      'banner': banner,
      'isAuthenticated': isAuthenticated,
      'karms': karms,
      'awards': awards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      banner: map['banner'] as String,
      isAuthenticated: map['isAuthenticated'] as bool,
      karms: map['karms'] as int,
      awards: List<String>.from((map['awards'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, profilePic: $profilePic, banner: $banner, isAuthenticated: $isAuthenticated, karms: $karms, awards: $awards)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.profilePic == profilePic &&
        other.banner == banner &&
        other.isAuthenticated == isAuthenticated &&
        other.karms == karms &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        profilePic.hashCode ^
        banner.hashCode ^
        isAuthenticated.hashCode ^
        karms.hashCode ^
        awards.hashCode;
  }
}

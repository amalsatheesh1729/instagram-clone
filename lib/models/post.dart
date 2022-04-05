class post
{
  final String description;
  final String uid;
  final String username;
  final String postId;
  final DateTime datepublished;
  final String postPhotoURL;
  final String profileImage;
  final likes;

  post({required this.description,required this.uid,required this.username,required this.postId,
    required this.datepublished,required this.postPhotoURL,required this.profileImage,required this.likes});

  Map<String,dynamic> toJsonMap()
  {
    return <String,dynamic>{
      'description':description,
      'uid':uid,
      'username':username,
      'postId':postId,
      'postPhotoURL':postPhotoURL,
      'profileImage':profileImage,
      'likes':likes,
      'datepublished':datepublished
    };
  }


}
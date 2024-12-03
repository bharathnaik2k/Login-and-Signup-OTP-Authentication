class GetPostModel {
  String? status;
  String? message;
  List<Data>? data;
  Null error;

  GetPostModel({this.status, this.message, this.data, this.error});

  GetPostModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    return data;
  }
}

class Data {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? serviceId;
  String? description;
  String? status;
  bool? liked;
  int? totalLikes;
  Author? author;
  List<Medias>? medias;

  Data(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.serviceId,
      this.description,
      this.status,
      this.liked,
      this.totalLikes,
      this.author,
      this.medias});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    serviceId = json['service_id'];
    description = json['description'];
    status = json['status'];
    liked = json['liked'];
    totalLikes = json['total_likes'];
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
    if (json['medias'] != null) {
      medias = <Medias>[];
      json['medias'].forEach((v) {
        medias!.add(Medias.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['service_id'] = serviceId;
    data['description'] = description;
    data['status'] = status;
    data['liked'] = liked;
    data['total_likes'] = totalLikes;
    if (author != null) {
      data['author'] = author!.toJson();
    }
    if (medias != null) {
      data['medias'] = medias!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Author {
  String? id;
  String? name;
  String? photoUrl;

  Author({this.id, this.name, this.photoUrl});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photo_url'] = photoUrl;
    return data;
  }
}

class Medias {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? postId;
  String? createdBy;
  String? fileName;
  String? url;
  String? storagePath;

  Medias(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.postId,
      this.createdBy,
      this.fileName,
      this.url,
      this.storagePath});

  Medias.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    postId = json['post_id'];
    createdBy = json['created_by'];
    fileName = json['file_name'];
    url = json['url'];
    storagePath = json['storage_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['post_id'] = postId;
    data['created_by'] = createdBy;
    data['file_name'] = fileName;
    data['url'] = url;
    data['storage_path'] = storagePath;
    return data;
  }
}

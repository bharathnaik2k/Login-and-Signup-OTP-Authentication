class ListModelclass {
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

  ListModelclass(
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

  ListModelclass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    serviceId = json['service_id'];
    description = json['description'];
    status = json['status'];
    liked = json['liked'];
    totalLikes = json['total_likes'];
    author =
        json['author'] != null ? new Author.fromJson(json['author']) : null;
    if (json['medias'] != null) {
      medias = <Medias>[];
      json['medias'].forEach((v) {
        medias!.add(new Medias.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['service_id'] = this.serviceId;
    data['description'] = this.description;
    data['status'] = this.status;
    data['liked'] = this.liked;
    data['total_likes'] = this.totalLikes;
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    if (this.medias != null) {
      data['medias'] = this.medias!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['photo_url'] = this.photoUrl;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['post_id'] = this.postId;
    data['created_by'] = this.createdBy;
    data['file_name'] = this.fileName;
    data['url'] = this.url;
    data['storage_path'] = this.storagePath;
    return data;
  }
}

class Data {
  String? url;
  Trailer? trailer;
  String? title;
  Images? images;
  Data({
    this.url,
    this.trailer,
    this.title,
    this.images,
  });

  Data.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    images = json['images'] != null ? Images.fromJson(json['images']) : null;
    trailer = json['trailer'] != null ? Trailer.fromJson(json['trailer']) : null;
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    if (trailer != null) {
      data['trailer'] = trailer!.toJson();
    }
    if (images != null) {
      data['images'] = images!.toJson();
    }
    data['title'] = title;
    return data;
  }
}
class Trailer {
  String? youtubeId;
  String? url;
  String? embedUrl;

  Trailer({this.youtubeId, this.url, this.embedUrl});

  Trailer.fromJson(Map<String, dynamic> json) {
    youtubeId = json['youtube_id']?.toString(); // Use ?. for null safety
    url = json['url']?.toString();
    embedUrl = json['embed_url']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['youtube_id'] = youtubeId;
    data['url'] = url;
    data['embed_url'] = embedUrl;
    return data;
  }
}
class Images {
  Jpg? jpg;
  Jpg? webp;

  Images({this.jpg, this.webp});

  Images.fromJson(Map<String, dynamic> json) {
    jpg = json['jpg'] != null ? Jpg.fromJson(json['jpg']) : null;
    webp = json['webp'] != null ? Jpg.fromJson(json['webp']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (jpg != null) {
      data['jpg'] = jpg!.toJson();
    }
    if (webp != null) {
      data['webp'] = webp!.toJson();
    }
    return data;
  }
}
class Jpg {
  String? imageUrl;
  String? smallImageUrl;
  String? largeImageUrl;

  Jpg({this.imageUrl, this.smallImageUrl, this.largeImageUrl});

  Jpg.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    smallImageUrl = json['small_image_url'];
    largeImageUrl = json['large_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_url'] = imageUrl;
    data['small_image_url'] = smallImageUrl;
    data['large_image_url'] = largeImageUrl;
    return data;
  }
}
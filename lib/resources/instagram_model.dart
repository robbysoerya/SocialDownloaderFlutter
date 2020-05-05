class InstagramModel {
  Graphql graphql;

  InstagramModel({this.graphql});

  InstagramModel.fromJson(Map<String, dynamic> json) {
    graphql =
        json['graphql'] != null ? new Graphql.fromJson(json['graphql']) : null;
  }
}

class Graphql {
  ShortcodeMedia shortcodeMedia;

  Graphql({this.shortcodeMedia});

  Graphql.fromJson(Map<String, dynamic> json) {
    shortcodeMedia = json['shortcode_media'] != null
        ? new ShortcodeMedia.fromJson(json['shortcode_media'])
        : null;
  }
}

class ShortcodeMedia {
  String sTypename;
  String id;
  String shortcode;
  Dimensions dimensions;
  String mediaPreview;
  String displayUrl;
  List<DisplayResources> displayResources;
  bool isVideo;
  String videoUrl;
  String trackingToken;
  EdgeMediaToCaption edgeMediaToCaption;
  bool viewerHasLiked;
  bool viewerHasSaved;
  bool viewerHasSavedToCollection;
  bool viewerInPhotoOfYou;
  bool viewerCanReshare;
  Owner owner;
  bool isAd;
  EdgeSideCarToChildren edgeSidecarToChildren;

  ShortcodeMedia(
      {this.sTypename,
      this.id,
      this.shortcode,
      this.dimensions,
      this.mediaPreview,
      this.displayUrl,
      this.displayResources,
      this.isVideo,
      this.videoUrl,
      this.trackingToken,
      this.edgeMediaToCaption,
      this.viewerHasLiked,
      this.viewerHasSaved,
      this.viewerHasSavedToCollection,
      this.viewerInPhotoOfYou,
      this.viewerCanReshare,
      this.owner,
      this.isAd,
      this.edgeSidecarToChildren});

  ShortcodeMedia.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    id = json['id'];
    shortcode = json['shortcode'];
    dimensions = json['dimensions'] != null
        ? new Dimensions.fromJson(json['dimensions'])
        : null;
    mediaPreview = json['media_preview'];
    displayUrl = json['display_url'];
    if (json['display_resources'] != null) {
      displayResources = new List<DisplayResources>();
      json['display_resources'].forEach((v) {
        displayResources.add(new DisplayResources.fromJson(v));
      });
    }
    isVideo = json['is_video'];
    videoUrl = json['video_url'];
    trackingToken = json['tracking_token'];
    edgeMediaToCaption = json['edge_media_to_caption'] != null
        ? new EdgeMediaToCaption.fromJson(json['edge_media_to_caption'])
        : null;
    viewerHasLiked = json['viewer_has_liked'];
    viewerHasSaved = json['viewer_has_saved'];
    viewerHasSavedToCollection = json['viewer_has_saved_to_collection'];
    viewerInPhotoOfYou = json['viewer_in_photo_of_you'];
    viewerCanReshare = json['viewer_can_reshare'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    isAd = json['is_ad'];
    edgeSidecarToChildren = json['edge_sidecar_to_children'] != null
        ? new EdgeSideCarToChildren.fromJson(json['edge_sidecar_to_children'])
        : null;
  }
}

class Dimensions {
  int height;
  int width;

  Dimensions({this.height, this.width});

  Dimensions.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['width'] = this.width;
    return data;
  }
}

class DisplayResources {
  String src;
  int configWidth;
  int configHeight;

  DisplayResources({this.src, this.configWidth, this.configHeight});

  DisplayResources.fromJson(Map<String, dynamic> json) {
    src = json['src'];
    configWidth = json['config_width'];
    configHeight = json['config_height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['src'] = this.src;
    data['config_width'] = this.configWidth;
    data['config_height'] = this.configHeight;
    return data;
  }
}

class EdgeMediaToCaption {
  List<Edges> edges;

  EdgeMediaToCaption({this.edges});

  EdgeMediaToCaption.fromJson(Map<String, dynamic> json) {
    if (json['edges'] != null) {
      edges = new List<Edges>();
      json['edges'].forEach((v) {
        edges.add(new Edges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.edges != null) {
      data['edges'] = this.edges.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Edges {
  Node node;

  Edges({this.node});

  Edges.fromJson(Map<String, dynamic> json) {
    node = json['node'] != null ? new Node.fromJson(json['node']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.node != null) {
      data['node'] = this.node.toJson();
    }
    return data;
  }
}

class Node {
  String text;

  Node({this.text});

  Node.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    return data;
  }
}

class Owner {
  String id;
  bool isVerified;
  String profilePicUrl;
  String username;
  bool blockedByViewer;
  bool restrictedByViewer;
  bool followedByViewer;
  String fullName;
  bool hasBlockedViewer;
  bool isPrivate;
  bool isUnpublished;
  bool requestedByViewer;
  EdgeOwnerToTimelineMedia edgeOwnerToTimelineMedia;

  Owner(
      {this.id,
      this.isVerified,
      this.profilePicUrl,
      this.username,
      this.blockedByViewer,
      this.restrictedByViewer,
      this.followedByViewer,
      this.fullName,
      this.hasBlockedViewer,
      this.isPrivate,
      this.isUnpublished,
      this.requestedByViewer,
      this.edgeOwnerToTimelineMedia});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isVerified = json['is_verified'];
    profilePicUrl = json['profile_pic_url'];
    username = json['username'];
    blockedByViewer = json['blocked_by_viewer'];
    restrictedByViewer = json['restricted_by_viewer'];
    followedByViewer = json['followed_by_viewer'];
    fullName = json['full_name'];
    hasBlockedViewer = json['has_blocked_viewer'];
    isPrivate = json['is_private'];
    isUnpublished = json['is_unpublished'];
    requestedByViewer = json['requested_by_viewer'];
    edgeOwnerToTimelineMedia = json['edge_owner_to_timeline_media'] != null
        ? new EdgeOwnerToTimelineMedia.fromJson(
            json['edge_owner_to_timeline_media'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_verified'] = this.isVerified;
    data['profile_pic_url'] = this.profilePicUrl;
    data['username'] = this.username;
    data['blocked_by_viewer'] = this.blockedByViewer;
    data['restricted_by_viewer'] = this.restrictedByViewer;
    data['followed_by_viewer'] = this.followedByViewer;
    data['full_name'] = this.fullName;
    data['has_blocked_viewer'] = this.hasBlockedViewer;
    data['is_private'] = this.isPrivate;
    data['is_unpublished'] = this.isUnpublished;
    data['requested_by_viewer'] = this.requestedByViewer;
    if (this.edgeOwnerToTimelineMedia != null) {
      data['edge_owner_to_timeline_media'] =
          this.edgeOwnerToTimelineMedia.toJson();
    }
    return data;
  }
}

class EdgeOwnerToTimelineMedia {
  int count;

  EdgeOwnerToTimelineMedia({this.count});

  EdgeOwnerToTimelineMedia.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}

class EdgeSideCarToChildren {
  List<Edges2> edges;

  EdgeSideCarToChildren({this.edges});

  EdgeSideCarToChildren.fromJson(Map<String, dynamic> json) {
    if (json['edges'] != null) {
      edges = new List<Edges2>();
      json['edges'].forEach((v) {
        edges.add(new Edges2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.edges != null) {
      data['edges'] = this.edges.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Edges2 {
  Node2 node;

  Edges2({this.node});

  Edges2.fromJson(Map<String, dynamic> json) {
    node = json['node'] != null ? new Node2.fromJson(json['node']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.node != null) {
      data['node'] = this.node.toJson();
    }
    return data;
  }
}

class Node2 {
  String sTypename;
  String id;
  String shortcode;
  Dimensions dimensions;
  String gatingInfo;
  String factCheckOverallRating;
  String factCheckInformation;
  String sensitivityFrictionInfo;
  String mediaOverlayInfo;
  String mediaPreview;
  String displayUrl;
  String videoUrl;
  List<DisplayResources> displayResources;
  String accessibilityCaption;
  bool isVideo;
  String trackingToken;

  Node2(
      {this.sTypename,
      this.id,
      this.shortcode,
      this.dimensions,
      this.gatingInfo,
      this.factCheckOverallRating,
      this.factCheckInformation,
      this.sensitivityFrictionInfo,
      this.mediaOverlayInfo,
      this.mediaPreview,
      this.videoUrl,
      this.displayUrl,
      this.displayResources,
      this.accessibilityCaption,
      this.isVideo,
      this.trackingToken});

  Node2.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    id = json['id'];
    shortcode = json['shortcode'];
    dimensions = json['dimensions'] != null
        ? new Dimensions.fromJson(json['dimensions'])
        : null;
    gatingInfo = json['gating_info'];
    factCheckOverallRating = json['fact_check_overall_rating'];
    factCheckInformation = json['fact_check_information'];
    sensitivityFrictionInfo = json['sensitivity_friction_info'];
    mediaOverlayInfo = json['media_overlay_info'];
    mediaPreview = json['media_preview'];
    displayUrl = json['display_url'];
    videoUrl = json['video_url'];
    if (json['display_resources'] != null) {
      displayResources = new List<DisplayResources>();
      json['display_resources'].forEach((v) {
        displayResources.add(new DisplayResources.fromJson(v));
      });
    }
    accessibilityCaption = json['accessibility_caption'];
    isVideo = json['is_video'];
    trackingToken = json['tracking_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['id'] = this.id;
    data['shortcode'] = this.shortcode;
    if (this.dimensions != null) {
      data['dimensions'] = this.dimensions.toJson();
    }
    data['gating_info'] = this.gatingInfo;
    data['fact_check_overall_rating'] = this.factCheckOverallRating;
    data['fact_check_information'] = this.factCheckInformation;
    data['sensitivity_friction_info'] = this.sensitivityFrictionInfo;
    data['media_overlay_info'] = this.mediaOverlayInfo;
    data['media_preview'] = this.mediaPreview;
    data['display_url'] = this.displayUrl;
    if (this.displayResources != null) {
      data['display_resources'] =
          this.displayResources.map((v) => v.toJson()).toList();
    }
    data['accessibility_caption'] = this.accessibilityCaption;
    data['is_video'] = this.isVideo;
    data['tracking_token'] = this.trackingToken;
    return data;
  }
}

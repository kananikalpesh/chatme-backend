enum Environment {
  development,
  stagging,
  production,
}

enum Tables {
  users("users"),
  opt("opt"),
  userRelation("user_relation"),
  medias("medias"),
  posts("posts"),
  stories("stories"),
  postRelation("post_relation"),
  storyRelation("story_relation");

  final String value;
  const Tables(this.value);
}

class CategoryDetail {
  final String name;
  final String image;
  final String description;
  final String id;

  CategoryDetail({
    required this.name,
    required this.image,
    required this.description,
    required this.id,
  });

  static List<CategoryDetail> getCategoryDetail() {
    List<CategoryDetail> categoryDetail = [];
    categoryDetail.add(CategoryDetail(
        name: "Mental Hobbies",
        image: "lib/assets/images/mental.jpg",
        description: "sda",
        id: "1"));
    categoryDetail.add(CategoryDetail(
        name: "Physical Hobbies",
        image: "lib/assets/images/physical.avif",
        description: "sda",
        id: "2"));
    categoryDetail.add(CategoryDetail(
        name: "Creative Hobbies",
        image: "lib/assets/images/creative.webp",
        description: "asd",
        id: "3"));
    categoryDetail.add(CategoryDetail(
        name: "Musical Hobbies",
        image: "lib/assets/images/music.avif",
        description: "asd",
        id: "4"));
    categoryDetail.add(CategoryDetail(
        name: "Collective Hobbies",
        image: "lib/assets/images/collective.jpeg",
        description: "asd",
        id: "5"));
    categoryDetail.add(CategoryDetail(
        name: "Games & Puzzles",
        image: "lib/assets/images/games.avif",
        description: "asd",
        id: "6"));

    return categoryDetail;
  }
}

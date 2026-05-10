class BibleVersesService {
  static const Map<String, List<String>> verses = {
    'louange': [
      'Psaume 113:3 - Du lever du soleil jusqu\'à son coucher, le nom de l\'Éternel est à louer.',
      'Psaume 100:1-2 - Poussez des cris de joie vers l\'Éternel, habitants de toute la terre! Servez l\'Éternel avec joie.',
      'Psaume 34:2 - Je bénirai l\'Éternel en tout temps; sa louange sera toujours dans ma bouche.',
    ],
    'adoration': [
      'Jean 4:24 - Dieu est esprit, et il faut que ceux qui l\'adorent l\'adorent en esprit et en vérité.',
      'Apocalypse 4:11 - Tu es digne, notre Seigneur et notre Dieu, de recevoir la gloire, l\'honneur et la puissance.',
      'Psaume 29:2 - Rendez à l\'Éternel la gloire due à son nom; prosternez-vous devant l\'Éternel dans son temple.',
    ],
    'intercession': [
      '1 Timothée 2:1 - Je recommande donc, avant toute chose, que l\'on fasse des prières, des supplications.',
      'Philippiens 4:6 - Ne vous inquiétez de rien; mais en toute chose faites connaître vos besoins à Dieu par des prières.',
      'Hébreux 10:19-20 - Ayant donc, frères, une libre entrée dans le sanctuaire par le sang de Jésus.',
    ],
    'action_de_grace': [
      'Philippiens 4:4-6 - Réjouissez-vous toujours dans le Seigneur; je le répète, réjouissez-vous.',
      'Colossiens 3:15-17 - Et que la paix de Christ, à laquelle vous avez été appelés pour former un seul corps, règne dans vos cœurs.',
      'Psaume 107:1 - Célébrez l\'Éternel, car il est bon, car sa miséricorde dure à jamais!',
    ],
    'repentance': [
      '1 Jean 1:8-9 - Si nous disons que nous n\'avons pas de péché, nous nous séduisons nous-mêmes, et la vérité n\'est pas en nous. Si nous confessons nos péchés, il est fidèle et juste pour nous les pardonner.',
      'Psaume 51:2-3 - Lave-moi complètement de mon iniquité, et purifie-moi de mon péché.',
      'Luc 15:18-19 - Je me lèverai, j\'irai vers mon père, et je lui dirai: Mon père, j\'ai péché contre le ciel et contre toi.',
    ],
    'benediction': [
      'Nombres 6:24-26 - Que l\'Éternel te bénisse et te garde! Que l\'Éternel fasse luire sa face sur toi et t\'accorde sa grâce!',
      '2 Corinthiens 13:13 - Que la grâce du Seigneur Jésus-Christ, l\'amour de Dieu, et la communion du Saint-Esprit soient avec vous tous!',
      'Éphésiens 1:3 - Béni soit le Dieu et Père de notre Seigneur Jésus-Christ, qui nous a bénis de toute bénédiction spirituelle.',
    ],
    'guerison': [
      'Proverbes 4:20-22 - Mon fils, sois attentif à mes paroles, prête l\'oreille à mes discours. Ils ne doivent pas s\'éloigner de tes yeux; garde-les dans ton cœur.',
      'Matthieu 8:16-17 - Le soir, on lui amena beaucoup de démoniaques. Il chassa les esprits par sa parole, et guérit tous les malades.',
      '3 Jean 1:2 - Bien-aimé, je souhaite que tu prospères à tous égards et que tu sois en bonne santé, comme prospère l\'état de ton âme.',
    ],
    'victoire': [
      'Romains 8:37 - Dans toutes ces choses nous sommes plus que vainqueurs par celui qui nous a aimés.',
      '1 Corinthiens 15:57 - Mais grâces soient rendues à Dieu, qui nous donne la victoire par notre Seigneur Jésus-Christ.',
      'Psaume 27:1 - L\'Éternel est ma lumière et mon salut; de qui aurais-je peur?',
    ],
    'protection': [
      'Psaume 91:4 - Il te couvrira de ses plumes, et sous ses ailes tu trouveras un refuge; sa fidélité est un bouclier.',
      'Proverbes 18:10 - Le nom de l\'Éternel est une tour forte; le juste s\'y réfugie et se met en sûreté.',
      '2 Timothée 1:7 - Car Dieu ne nous a pas donné un esprit de timidité, mais un esprit de force, d\'amour et de sagesse.',
    ],
    'sagesse': [
      'Proverbes 3:13-14 - Heureux l\'homme qui a trouvé la sagesse, et l\'homme qui possède l\'intelligence!',
      'Jacques 1:5 - Si quelqu\'un d\'entre vous manque de sagesse, qu\'il la demande à Dieu, qui donne à tous simplement et sans reproche.',
      'Proverbes 8:11 - Car la sagesse vaut mieux que les perles; elle a plus de prix que tout ce qu\'on peut désirer.',
    ],
  };

  static String getRandomVerse(String? category) {
    final key = category ?? 'louange';
    final verseList = verses[key] ?? verses['louange']!;
    verseList.shuffle();
    return verseList.first;
  }

  static List<String> getVersesByCategory(String category) {
    return verses[category] ?? verses['louange']!;
  }

  static String getRandomVerseAny() {
    final allVerses = verses.values.expand((v) => v).toList();
    allVerses.shuffle();
    return allVerses.first;
  }
}

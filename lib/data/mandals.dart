// lib/data/mandals.dart

class Mandal {
  final String name;
  final String area;
  final String tag; // "Manacha" / "Famous" / "Other"
  final int? manachaRank;
  final String entry;
  final String exit;
  final String timings;
  final String? image;
  final String? year2025;
  final String? history;
  final String? speciality;
  final String? description;
  final double? lat;
  final double? lng;

  const Mandal({
    required this.name,
    required this.area,
    required this.tag,
    this.manachaRank,
    required this.entry,
    required this.exit,
    required this.timings,
    this.image,
    this.year2025,
    this.history,
    this.speciality,
    this.description,
    this.lat,
    this.lng,
  });
}

// ================= MASTER LIST =================
// Abhi ke liye 24 Mandals added hai.
// Aage jitne bhi naye buildings / mandals add karne ho
// sirf niche list me copy-paste style se add karo.

const List<Mandal> kMandals = [
  // ---------- Manacha Ganpati (1 to 5) ----------
  Mandal(
    name: "Kasba Ganpati",
    area: "Kasba Peth",
    tag: "Manacha",
    manachaRank: 1,
    entry: "Kasba Peth East",
    exit: "Kasba Peth West",
    timings: "6:00 AM – 12:00 AM",
    image: 'assets/mandals/kasba.jpeg',
    year2025: "Ballaleshwar Temple",
    history: "City’s Gram Daivat; Jijabai Bhosale ne sthapna ki.",
    speciality: "Simple traditional idol; first in immersion.",
    description: "Pune ka Gramdaivat. Manacha Pahila Ganpati jahan se visarjan shuru hota hai.",
    lat: 18.5191,
    lng: 73.8574,
  ),

  Mandal(
    name: "Tambdi Jogeshwari Ganpati",
    area: "Budhwar Peth",
    tag: "Manacha",
    manachaRank: 2,
    entry: "Jogeshwari Temple Lane",
    exit: "Budhwar Peth Chowk",
    timings: "6:00 AM – 12:00 AM",
    image: 'assets/mandals/tambdi.jpeg',
    year2025: "Cultural programs",
    history: "Jogeshwari Devi temple se juda.",
    speciality: "Deep red backdrop ('Tambdi').",
    description: "Jogeshwari Mata temple ke paas sthit, prachin aur pavitra sthaan.",
    lat: 18.52043,
    lng: 73.85674,
  ),

  Mandal(
    name: "Guruji Talim Ganpati",
    area: "Guruji Talim Chowk",
    tag: "Manacha",
    manachaRank: 3,
    entry: "Laxmi Road Side",
    exit: "Kelkar Road",
    timings: "6:00 AM – 12:00 AM",
    image: 'assets/mandals/gurujitalim.jpeg',
    year2025: "Silver chariot & digital lights",
    history: "1887; Hindu–Muslim unity symbol.",
    speciality: "Mythological decor with silver ornaments.",
    description: "Hindu-Muslim ekta ka prateek Ganpati jo 1887 me sthapit hua.",
    lat: 18.52043,
    lng: 73.85674,
  ),

  Mandal(
    name: "Tulshibaug Ganpati",
    area: "Tulshibaug",
    tag: "Manacha",
    manachaRank: 4,
    entry: "Tulshibaug Market Gate",
    exit: "Tilak Road",
    timings: "6:00 AM – 12:00 AM",
    image: 'assets/mandals/tulshibaug.jpeg',
    year2025: "Vrindavan theme",
    history: "Since 1901.",
    speciality: "13–15 ft idol; silver & fiberglass work.",
    description: "Sabse bada idol jo Tulshibaug ke bazaar me sthit hai.",
    lat: 18.5149,
    lng: 73.8530,
  ),

  Mandal(
    name: "Kesariwada Ganpati",
    area: "Narayan Peth",
    tag: "Manacha",
    manachaRank: 5,
    entry: "Kesariwada Gate",
    exit: "NC Kelkar Road",
    timings: "6:00 AM – 12:00 AM",
    image: 'assets/mandals/kesariwada.jpeg',
    year2025: "Cultural palkhi shobhayatra",
    history: "Tilak ne 1893 me public Ganeshotsav yahin se shuru kiya.",
    speciality: "Tilak legacy; palkhi traditions.",
    description: "Bal Gangadhar Tilak ke Kesariwada se Lokmanya ne public Ganeshotsav ki shuruaat ki thi.",
    lat: 18.5192,
    lng: 73.8570,
  ),

  // ---------- Famous Ganpati ----------
  Mandal(
    name: "Shrimant Dagdusheth Halwai Ganpati",
    area: "Budhwar Peth",
    tag: "Famous",
    entry: "Main Gate (Budhwar Peth)",
    exit: "River Side Lane",
    timings: "6:00 AM – 1:00 AM",
    image: 'assets/mandals/dagdusheth.jpeg',
    year2025: "Chenda Melam & light show",
    history: "Dagdusheth Halwai ne bete ke nidhana ke baad sthapna ki.",
    speciality: "2.2 m idol, 40+ kg gold; lakhon bhakt.",
    description: "Pune ka sabse prasiddh Ganpati. Har saal celebrities aur politicians bhi yahan darshan lete hain.",
    lat: 18.51639,
    lng: 73.85580,
  ),

  Mandal(
    name: "Shrimant Bhausaheb Rangari Ganpati",
    area: "Kasba Peth",
    tag: "Famous",
    entry: "Rangari Bhavan Lane",
    exit: "Kasba Peth Chowk",
    timings: "6:00 AM – 12:00 AM",
    image: 'assets/mandals/rangari.jpeg',
    year2025: "Original historical idol",
    history: "India ka pehla public Ganpati Utsav (1892).",
    speciality: "Ganpati asur ko maarte hue — sahas ka prateek.",
    description: "Sabse pehla public Ganpati jo freedom struggle ke dauran sthapit hua tha.",
    lat: 18.5190,
    lng: 73.8565,
  ),

  Mandal(
    name: "Akhil Mandai Mandal Ganpati",
    area: "Mandai",
    tag: "Famous",
    entry: "Phule Mandai Gate",
    exit: "Vegetable Market Side",
    timings: "6:30 AM – 11:30 PM",
    image: 'assets/mandals/mandai.jpeg',
    year2025: "Grand illumination",
    history: "Phule Mandai market area se juda.",
    speciality: "Idol jhoola par; saath me Goddess Sharada.",
    description: "Mandai ke beech sthit, cultural aur mythological decor ke liye famous.",
    lat: 18.52043,
    lng: 73.85674,
  ),

  Mandal(
    name: "Natu Baug Ganpati",
    area: "Sadashiv Peth",
    tag: "Famous",
    entry: "Tilak Road Corner",
    exit: "Natu Baug Lane",
    timings: "6:00 AM – 11:30 PM",
    image: null,
    year2025: "Signature lighting",
    history: "Grand lighting & crowds.",
    speciality: "Lighting aur grandeur ke liye prasiddh.",
    description: "Lighting aur decoration ke liye prasiddh Ganpati jo Sadashiv Peth me sthit hai.",
    lat: 18.5159,
    lng: 73.8540,
  ),

  // ---------- Additional Famous (8 mandals) ----------
  Mandal(
    name: "Chhatrapati Rajaram Mandal",
    area: "Sadashiv Peth",
    tag: "Famous",
    entry: "Tilak Road",
    exit: "Perugate Side",
    timings: "6:30 AM – 11:30 PM",
    image: null,
    year2025: "Warrior-themed decor",
    description: "Chhatrapati Rajaram Maharaj ki veerta par aadharit decoration aur idol themes.",
    lat: 18.52043,
    lng: 73.85674,
  ),

  Mandal(
    name: "Shaniwar Mandal",
    area: "Shaniwar Peth",
    tag: "Famous",
    entry: "Shaniwar Peth Junction",
    exit: "River Bank Lane",
    timings: "6:30 AM – 11:30 PM",
    image: null,
    year2025: "Traditional immersion dindi",
    description: "Shaniwar Wada aur parivarik itihaas se juda hua mandal.",
    lat: 18.5195,
    lng: 73.8560,
  ),

  Mandal(
    name: "Akkar Maruti Chowk Ganesh Mandal",
    area: "Shukrawar Peth",
    tag: "Famous",
    entry: "Maruti Chowk",
    exit: "Shukrawar Peth Main Road",
    timings: "6:30 AM – 11:00 PM",
    image: null,
    year2025: "Community programs",
    description: "Local community ke cultural aur social programs ke liye mashhoor.",
    lat: 18.5198,
    lng: 73.8562,
  ),

  Mandal(
    name: "Hutatma Babu Genu Ganesh Mandal",
    area: "Budhwar Peth",
    tag: "Famous",
    entry: "Babu Genu Chowk",
    exit: "Budhwar Peth Signal",
    timings: "6:30 AM – 11:30 PM",
    image: null,
    year2025: "Historic tribute events",
    description: "Freedom fighter Babu Genu ki yaad me sthapit, itihaasik mahatva rakhta hai.",
    lat: 18.5178,
    lng: 73.8563,
  ),

  Mandal(
    name: "Hatti Ganpati Mandal",
    area: "Sahitya Parishad / Laxmi Road area",
    tag: "Famous",
    entry: "Perugate",
    exit: "Sadashiv Peth Lane",
    timings: "6:30 AM – 11:00 PM",
    image: 'assets/mandals/hatti.jpeg',
    year2025: "Traditional aarti",
    description: "Hatti Ganpati apni traditional pooja aur bhajan sandhya ke liye prasiddh hai.",
    lat: 18.5160,
    lng: 73.8560,
  ),


  Mandal(
    name: "Hirabaug Mitra Mandal",
    area: "Shukrawar Peth",
    tag: "Famous",
    entry: "Hirabaug Corner",
    exit: "Tilak Road",
    timings: "6:30 AM – 11:00 PM",
    image: null,
    year2025: "Thematic decor",
    description: "Thematic decoration aur alag idol design ke liye prasiddh.",
    lat: 18.5202,
    lng: 73.8566,
  ),

  Mandal(
    name: "Shree Sai Mitra Mandal",
    area: "Kothrud",
    tag: "Famous",
    entry: "Paud Road",
    exit: "DP Road",
    timings: "6:30 AM – 11:00 PM",
    image: null,
    year2025: "Queue mgmt upgrades",
    description: "Kothrud ka prasiddh Ganpati, acchi queue management aur seva karyakram ke liye jaana jata hai.",
    lat: 18.5040,
    lng: 73.8280,
  ),

  // ---------- ROUTE-SPECIFIC / MISSING Ganpatis ADDED ----------
  Mandal(
    name: "Saneguruji Mandal (Mahalaxmi)",
    area: "Dandekar Bridge",
    tag: "Other",
    entry: "Near Dandekar Bridge",
    exit: "Mahalaxmi Road",
    timings: "6:00 AM – 11:00 PM",
    image: 'assets/mandals/saneguruji.jpeg',
    year2025: "Small cultural programs",
    history: "Local neighborhood mandal, traditional celebrations.",
    speciality: "Community bhajans & small processions.",
    description: "Mahalaxmi area ke paas; bike se aaram se visit ho sakta hai.",
    lat: 18.5186,
    lng: 73.8558,
  ),

  Mandal(
    name: "Garud Ganpati",
    area: "Laxmi Road (near Alka Talkies)",
    tag: "Other",
    entry: "Laxmi Road Entrance",
    exit: "Alka Talkies Lane",
    timings: "6:00 AM – 11:30 PM",
    image: 'assets/mandals/garud.jpeg',
    year2025: "Local street decor",
    history: "Chhota par popular mandal Laxmi Road par.",
    speciality: "Rapid darshan; morning crowd heavy.",
    description: "Laxmi Road ke nazdeek, shopping route par sthit mandal.",
    lat: 18.5175,
    lng: 73.8570,
  ),

  Mandal(
    name: "Mati Ganpati",
    area: "Narayan Peth",
    tag: "Other",
    entry: "Narayan Peth Gate",
    exit: "Gondya Ala Re Lane",
    timings: "6:00 AM – 11:30 PM",
    image: 'assets/mandals/mati.jpeg',
    year2025: "Folk performances",
    history: "Local mandal known for clay (mati) themed decor.",
    speciality: "Clay based theme & eco-friendly idol.",
    description: "Narayan Peth me sthit; ground-level cultural activities.",
    lat: 18.5127,
    lng: 73.8551,
  ),

  Mandal(
    name: "Bholenath Mitra Mandal",
    area: "Kesari Wada (in front of Kesari Wada)",
    tag: "Other",
    entry: "Kesari Wada Front",
    exit: "Kesari Lane",
    timings: "6:00 AM – 11:30 PM",
    image: 'assets/mandals/bholenath.jpeg',
    year2025: "Kirtan & palkhi",
    history: "Local mitra mandal with traditional processions.",
    speciality: "Strong devotional kirtan sessions.",
    description: "Kesari Wada ke samne; Tilak tradition se juda mandal.",
    lat: 18.5190,
    lng: 73.8568,
  ),

  Mandal(
    name: "Munjabacha Bol Mandal",
    area: "Narayan Peth",
    tag: "Other",
    entry: "Narayan Peth Main",
    exit: "Sant Dnyaneshwar Road",
    timings: "6:00 AM – 11:00 PM",
    image: 'assets/mandals/munjabacha.jpeg',
    year2025: "Local devotional groups",
    history: "Famous among local crowds for bhajan schedule.",
    speciality: "Energetic bhajan & community seva.",
    description: "Narayan Peth ka popular mandal; walking route me aasani se cover hota hai.",
    lat: 18.5139,
    lng: 73.8548,
  ),

  Mandal(
    name: "Jilbya Maruti Ganpati",
    area: "Tulshibaug area",
    tag: "Other",
    entry: "Near Tulshibaug Market",
    exit: "12 Jyotirlingas Lane",
    timings: "6:00 AM – 11:30 PM",
    image: 'assets/mandals/jilbya.jpeg',
    year2025: "Small ensemble shows",
    history: "Local deity with strong devotees from market community.",
    speciality: "Maruti stuti & local aarti.",
    description: "Tulshibaug ke aaspas, small but lively mandal.",
    lat: 18.5149,
    lng: 73.8532,
  ),

  Mandal(
    name: "Shanipar Trust / Jalmay Dwarka",
    area: "Tulshibaug vicinity",
    tag: "Other",
    entry: "Shanipar Lane",
    exit: "Jalmay Dwarka Path",
    timings: "6:00 AM – 11:00 PM",
    image: 'assets/mandals/shanipar.jpeg',
    year2025: "Community seva stalls",
    history: "Trust-run mandal focusing on charity and service.",
    speciality: "Community kitchen & help desks.",
    description: "Tulshibaug ke paas; seva aur support facilities available.",
    lat: 18.5151,
    lng: 73.8525,
  ),

  // ---------- TODO: Add More Buildings / Mandals ----------
  // Yahan par aap aur mandals ya buildings add kar sakte ho future me.
];

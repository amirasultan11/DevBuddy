import '../models/work_style_model.dart';
import '../models/track_model.dart';
import '../models/roadmap_step_model.dart';
import '../models/tip_model.dart';
import '../models/resource_model.dart';
import '../models/mentor_model.dart';
import '../../../auth/data/models/user_profile_model.dart';

/// Provides realistic mock data for the Pro Mode feature
/// This simulates a real EdTech platform with actual industry data
class DummyDataSource {
  /// Returns realistic work style options with actual pros/cons and salary data
  static List<WorkStyleModel> getWorkStyles() {
    return [
      // Freelance Work Style
      WorkStyleModel(
        id: 'ws_001',
        title: 'Freelance Developer',
        description:
            'Work independently on projects for multiple clients. Set your own hours, choose your projects, and work from anywhere. Perfect for self-motivated individuals who value freedom and flexibility.',
        suitablePersonalityTypes: ['INTJ', 'INTP', 'ISTP', 'ENTP'],
        pros: [
          'Complete flexibility in schedule and location',
          'Choose projects that interest you',
          'Higher hourly rates compared to employment',
          'Direct client relationships',
          'Tax benefits and business deductions',
          'Unlimited income potential',
          'Build diverse portfolio across industries',
        ],
        cons: [
          'Inconsistent income and cash flow',
          'No paid vacation or sick leave',
          'Must handle own taxes and accounting',
          'Constant client acquisition needed',
          'No employer-provided benefits (health insurance, retirement)',
          'Isolation and lack of team collaboration',
          'Scope creep and difficult clients',
        ],
        avgSalaryRange: {
          'minEGP': 15000.0, // Junior freelancer per month
          'maxEGP': 80000.0, // Senior freelancer per month
          'minUSD': 25000.0, // Junior per year (global)
          'maxUSD': 150000.0, // Senior per year (global)
        },
        requiredSoftSkills: [
          'Self-discipline and time management',
          'Client communication and negotiation',
          'Financial planning and budgeting',
          'Marketing and personal branding',
          'Problem-solving independently',
          'Adaptability to different projects',
        ],
      ),

      // Startup Work Style
      WorkStyleModel(
        id: 'ws_002',
        title: 'Startup Team Member',
        description:
            'Join a fast-paced startup environment where you wear multiple hats and directly impact product success. High risk, high reward with potential equity compensation.',
        suitablePersonalityTypes: ['ENTP', 'ENFP', 'ENTJ', 'ESTP'],
        pros: [
          'Equity/stock options with potential for huge returns',
          'Rapid learning and skill development',
          'Direct impact on product and company direction',
          'Wear multiple hats and learn various roles',
          'Innovative and creative environment',
          'Close-knit team culture',
          'Opportunity to build something from scratch',
        ],
        cons: [
          'Long working hours (60-80 hours/week common)',
          'High stress and uncertainty',
          'Lower initial salary than corporate',
          'Risk of company failure (90% fail)',
          'Equity may become worthless',
          'Limited resources and budget constraints',
          'Constantly changing priorities',
        ],
        avgSalaryRange: {
          'minEGP': 12000.0, // Early-stage startup
          'maxEGP': 45000.0, // Well-funded startup + equity
          'minUSD': 40000.0, // Early-stage (global)
          'maxUSD': 120000.0, // Well-funded + equity (global)
        },
        requiredSoftSkills: [
          'Resilience and stress management',
          'Adaptability to rapid changes',
          'Entrepreneurial mindset',
          'Collaborative teamwork',
          'Creative problem-solving',
          'Passion and intrinsic motivation',
        ],
      ),

      // Corporate Work Style
      WorkStyleModel(
        id: 'ws_003',
        title: 'Corporate Developer',
        description:
            'Work for established companies with structured environments, clear career paths, and comprehensive benefits. Stability and work-life balance prioritized.',
        suitablePersonalityTypes: ['ISTJ', 'ISFJ', 'ESTJ', 'INTJ'],
        pros: [
          'Stable monthly salary and benefits',
          'Health insurance and retirement plans',
          'Paid vacation and sick leave',
          'Clear career progression path',
          'Structured work hours (9-5 typically)',
          'Learning and development budgets',
          'Team collaboration and mentorship',
          'Job security and stability',
        ],
        cons: [
          'Bureaucracy and slow decision-making',
          'Limited creative freedom',
          'Office politics and hierarchy',
          'Slower career growth compared to startups',
          'May work on legacy systems',
          'Less direct impact on product',
          'Rigid processes and procedures',
        ],
        avgSalaryRange: {
          'minEGP': 18000.0, // Junior developer
          'maxEGP': 65000.0, // Senior/Lead developer
          'minUSD': 60000.0, // Junior (global)
          'maxUSD': 180000.0, // Senior/Staff (global)
        },
        requiredSoftSkills: [
          'Professional communication',
          'Team collaboration',
          'Following processes and procedures',
          'Stakeholder management',
          'Documentation skills',
          'Patience and diplomacy',
        ],
      ),
    ];
  }

  /// Returns realistic learning tracks with actual market data
  static List<TrackModel> getTracks() {
    return [
      // Flutter Track
      TrackModel(
        id: 'track_001',
        title: 'Flutter Development',
        description:
            'Master cross-platform mobile development with Flutter. Build beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.',
        marketDemand: MarketDemand.high,
        avgSalaryEgypt: 25000.0, // EGP per month
        avgSalaryGlobal: 85000.0, // USD per year
        readinessScore: ReadinessScore.ready,
        prerequisites: [
          'Basic programming concepts (variables, loops, functions)',
          'Object-Oriented Programming (OOP)',
          'Basic understanding of mobile UI/UX',
          'Git version control basics',
        ],
        toolsRequired: [
          'Flutter SDK',
          'Android Studio / VS Code',
          'Dart programming language',
          'Firebase (for backend)',
          'Git & GitHub',
          'Figma (for design)',
        ],
        estimatedHours: 180,
        difficultyLevel: 3,
        icon: '📱',
        colorHex: '#02569B',
      ),

      // AI/ML Track
      TrackModel(
        id: 'track_002',
        title: 'AI & Machine Learning',
        description:
            'Dive into artificial intelligence and machine learning. Learn to build intelligent systems that can learn from data and make predictions.',
        marketDemand: MarketDemand.high,
        avgSalaryEgypt: 35000.0, // EGP per month
        avgSalaryGlobal: 120000.0, // USD per year
        readinessScore: ReadinessScore.almost,
        prerequisites: [
          'Python programming',
          'Mathematics (Linear Algebra, Calculus, Statistics)',
          'Data structures and algorithms',
          'Basic understanding of databases',
        ],
        toolsRequired: [
          'Python',
          'TensorFlow / PyTorch',
          'Jupyter Notebook',
          'NumPy, Pandas, Scikit-learn',
          'Google Colab',
          'Git & GitHub',
        ],
        estimatedHours: 250,
        difficultyLevel: 5,
        icon: '🤖',
        colorHex: '#FF6F00',
      ),

      // Backend Development Track
      TrackModel(
        id: 'track_003',
        title: 'Backend Development (Node.js)',
        description:
            'Build scalable server-side applications and APIs. Learn database design, authentication, and cloud deployment.',
        marketDemand: MarketDemand.high,
        avgSalaryEgypt: 28000.0, // EGP per month
        avgSalaryGlobal: 95000.0, // USD per year
        readinessScore: ReadinessScore.ready,
        prerequisites: [
          'JavaScript fundamentals',
          'Basic understanding of HTTP and REST APIs',
          'Command line basics',
          'Git version control',
        ],
        toolsRequired: [
          'Node.js & npm',
          'Express.js framework',
          'MongoDB / PostgreSQL',
          'Postman (API testing)',
          'Docker',
          'AWS / Heroku',
        ],
        estimatedHours: 200,
        difficultyLevel: 4,
        icon: '⚙️',
        colorHex: '#68A063',
      ),

      // UI/UX Design Track
      TrackModel(
        id: 'track_004',
        title: 'UI/UX Design',
        description:
            'Create beautiful and user-friendly interfaces. Learn design principles, user research, prototyping, and design systems.',
        marketDemand: MarketDemand.medium,
        avgSalaryEgypt: 20000.0, // EGP per month
        avgSalaryGlobal: 75000.0, // USD per year
        readinessScore: ReadinessScore.ready,
        prerequisites: [
          'Basic design principles',
          'Understanding of color theory',
          'Familiarity with design tools',
        ],
        toolsRequired: [
          'Figma',
          'Adobe XD',
          'Sketch',
          'InVision',
          'Miro (for user flows)',
          'Notion (for documentation)',
        ],
        estimatedHours: 150,
        difficultyLevel: 2,
        icon: '🎨',
        colorHex: '#F24E1E',
      ),
    ];
  }

  /// Returns realistic roadmap steps for Flutter track with actual resources
  static List<RoadmapStepModel> getFlutterRoadmapSteps() {
    return [
      RoadmapStepModel(
        id: 'step_001',
        trackId: 'track_001',
        title: 'Dart Fundamentals',
        description:
            'Master the Dart programming language - the foundation of Flutter. Learn variables, functions, OOP, async programming, and null safety.',
        order: 1,
        isLocked: false,
        isCompleted: false,
        type: StepType.lesson,
        resources: [
          LearningResource(
            type: 'documentation',
            title: 'Official Dart Language Tour',
            url: 'https://dart.dev/guides/language/language-tour',
            isFree: true,
          ),
          LearningResource(
            type: 'book',
            title: 'Dart Apprentice',
            url: 'https://www.raywenderlich.com/books/dart-apprentice',
            isFree: false,
            author: 'raywenderlich.com',
          ),
          LearningResource(
            type: 'video',
            title: 'Dart Programming Tutorial - Full Course',
            url: 'https://www.youtube.com/watch?v=Ej_Pcr4uC2Q',
            isFree: true,
            author: 'freeCodeCamp',
          ),
        ],
        commonMistakes: [
          'Not understanding null safety properly',
          'Confusing async/await with synchronous code',
          'Overusing dynamic type instead of strong typing',
          'Not utilizing Dart\'s collection methods (map, where, reduce)',
        ],
        estimatedHours: 25.0,
        pointsReward: 100,
        skillsLearned: [
          'Dart syntax and semantics',
          'Object-Oriented Programming',
          'Asynchronous programming',
          'Null safety',
        ],
        practicalTips: [
          'Practice on DartPad daily',
          'Read official documentation thoroughly',
          'Complete coding challenges on LeetCode using Dart',
        ],
      ),
      RoadmapStepModel(
        id: 'step_002',
        trackId: 'track_001',
        title: 'Flutter Basics & Widgets',
        description:
            'Learn Flutter\'s widget tree, stateless vs stateful widgets, and build your first interactive UI.',
        order: 2,
        isLocked: false,
        isCompleted: false,
        type: StepType.lesson,
        resources: [
          LearningResource(
            type: 'documentation',
            title: 'Flutter Widget Catalog',
            url: 'https://docs.flutter.dev/development/ui/widgets',
            isFree: true,
          ),
          LearningResource(
            type: 'book',
            title: 'Flutter Apprentice',
            url: 'https://www.raywenderlich.com/books/flutter-apprentice',
            isFree: false,
            author: 'raywenderlich.com',
          ),
          LearningResource(
            type: 'video',
            title: 'Flutter Course for Beginners',
            url: 'https://www.youtube.com/watch?v=VPvVD8t02U8',
            isFree: true,
            author: 'freeCodeCamp',
          ),
        ],
        commonMistakes: [
          'Not understanding the difference between StatelessWidget and StatefulWidget',
          'Rebuilding entire widget tree unnecessarily',
          'Not using const constructors for performance',
          'Deeply nesting widgets instead of extracting to separate widgets',
        ],
        estimatedHours: 30.0,
        pointsReward: 150,
        skillsLearned: [
          'Widget composition',
          'State management basics',
          'Layout and styling',
          'Handling user input',
        ],
        practicalTips: [
          'Build small UI clones (Instagram card, Twitter feed)',
          'Use Flutter DevTools to inspect widget tree',
          'Always extract complex widgets into separate classes',
        ],
      ),
      RoadmapStepModel(
        id: 'step_003',
        trackId: 'track_001',
        title: 'State Management with BLoC',
        description:
            'Master the BLoC pattern for scalable state management. Learn to separate business logic from UI.',
        order: 3,
        isLocked: true,
        isCompleted: false,
        type: StepType.lesson,
        resources: [
          LearningResource(
            type: 'documentation',
            title: 'flutter_bloc Official Documentation',
            url: 'https://bloclibrary.dev/',
            isFree: true,
          ),
          LearningResource(
            type: 'video',
            title: 'Flutter BLoC - Complete Course',
            url: 'https://www.youtube.com/watch?v=THCkkQ-V1-8',
            isFree: true,
            author: 'Reso Coder',
          ),
          LearningResource(
            type: 'article',
            title: 'BLoC Pattern Best Practices',
            url: 'https://verygood.ventures/blog/flutter-bloc-best-practices',
            isFree: true,
            author: 'Very Good Ventures',
          ),
        ],
        commonMistakes: [
          'Putting UI logic inside BLoC',
          'Not closing streams properly',
          'Creating too many BLoCs',
          'Not using Equatable for state comparison',
        ],
        estimatedHours: 20.0,
        pointsReward: 200,
        skillsLearned: [
          'BLoC pattern architecture',
          'Stream management',
          'Event-driven programming',
          'Clean architecture principles',
        ],
        practicalTips: [
          'Start with simple Cubit before moving to BLoC',
          'Use BlocObserver for debugging',
          'Follow the official BLoC architecture guidelines',
        ],
      ),
      RoadmapStepModel(
        id: 'step_004',
        trackId: 'track_001',
        title: 'Build a Complete App',
        description:
            'Apply everything you\'ve learned by building a full-featured app with authentication, API integration, and local storage.',
        order: 4,
        isLocked: true,
        isCompleted: false,
        type: StepType.project,
        resources: [
          LearningResource(
            type: 'book',
            title: 'Clean Code',
            url:
                'https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882',
            isFree: false,
            author: 'Robert C. Martin',
          ),
          LearningResource(
            type: 'article',
            title: 'Flutter App Architecture Best Practices',
            url:
                'https://codewithandrea.com/articles/flutter-app-architecture-domain-model-repository-pattern/',
            isFree: true,
            author: 'Andrea Bizzotto',
          ),
        ],
        commonMistakes: [
          'Not planning architecture before coding',
          'Skipping error handling',
          'Not writing tests',
          'Poor folder structure',
        ],
        estimatedHours: 40.0,
        pointsReward: 500,
        skillsLearned: [
          'Full app development lifecycle',
          'API integration',
          'Authentication flows',
          'Local data persistence',
        ],
        practicalTips: [
          'Plan your features and architecture first',
          'Use Firebase for quick backend setup',
          'Write tests as you build features',
          'Get code reviews from experienced developers',
        ],
      ),
    ];
  }

  /// Returns a sample user profile with realistic data
  static UserProfileModel getSampleUserProfile() {
    return UserProfileModel(
      uid: 'user_12345',
      name: 'Ahmed Hassan',
      email: 'ahmed.hassan@example.com',
      phoneNumber: '+201234567890',
      personalityType: 'INTJ',
      currentStreak: 7,
      longestStreak: 21,
      totalPoints: 3500,
      level: 3, // Level 3 (3500 points / 1000)
      completedTracks: ['track_004'], // Completed UI/UX Design
      enrolledTracks: ['track_001', 'track_003'], // Flutter and Backend
      preferredWorkStyle: 'ws_001', // Freelance
      avatar: '👨‍💻',
      createdAt: DateTime(2025, 10, 15),
      lastLoginAt: DateTime.now(),
      isKidsMode: false,
      preferredLanguage: 'ar',
      badges: [
        Badge(
          id: 'badge_001',
          title: 'First Steps',
          icon: '🎯',
          earnedAt: DateTime(2025, 10, 16),
        ),
        Badge(
          id: 'badge_002',
          title: '7-Day Streak',
          icon: '🔥',
          earnedAt: DateTime.now(),
        ),
        Badge(
          id: 'badge_003',
          title: 'Track Completed',
          icon: '🏆',
          earnedAt: DateTime(2026, 1, 20),
        ),
      ],
      learningStats: LearningStats(
        totalHours: 85.5,
        completedLessons: 42,
        completedQuizzes: 15,
        completedProjects: 3,
        avgQuizScore: 87.5,
      ),
      bio:
          'Aspiring Flutter developer passionate about building beautiful mobile apps',
      currentGoal: 'Complete Flutter Development track by March 2026',
    );
  }

  /// Get a specific track by ID
  /// Returns null if track not found
  static TrackModel? getTrackById(String trackId) {
    try {
      return getTracks().firstWhere((track) => track.id == trackId);
    } catch (e) {
      return null;
    }
  }

  /// Get a specific work style by ID
  /// Returns null if work style not found
  static WorkStyleModel? getWorkStyleById(String workStyleId) {
    try {
      return getWorkStyles().firstWhere((ws) => ws.id == workStyleId);
    } catch (e) {
      return null;
    }
  }

  /// Get roadmap steps for a specific track
  /// Currently only Flutter track has roadmap steps
  /// Returns empty list for other tracks
  static List<RoadmapStepModel> getRoadmapByTrackId(String trackId) {
    switch (trackId) {
      case 'track_001':
        // Flutter track
        return getFlutterRoadmapSteps();
      case 'track_002':
      case 'track_003':
      case 'track_004':
        // Other tracks - return empty list for now
        // In a real app, these would have their own roadmap steps
        return [];
      default:
        return [];
    }
  }

  /// Verify OTP code (for authentication)
  /// In production, this would call a backend API
  /// For testing, accepts '123456' as valid OTP
  static bool verifyOtp(String phoneNumber, String otp) {
    // Validate phone number format (Egyptian format)
    final egyptRegex = RegExp(r'^\+20[0-9]{10}$');
    if (!egyptRegex.hasMatch(phoneNumber)) {
      return false;
    }

    // Check if OTP is valid (hardcoded for testing)
    return otp == '123456';
  }

  /// Get all roadmap steps across all tracks
  static List<RoadmapStepModel> getAllRoadmapSteps() {
    return [
      ...getFlutterRoadmapSteps(),
      // Add other track roadmaps here when available
    ];
  }

  /// Get a specific roadmap step by ID
  static RoadmapStepModel? getRoadmapStepById(String stepId) {
    try {
      return getAllRoadmapSteps().firstWhere((step) => step.id == stepId);
    } catch (e) {
      return null;
    }
  }

  /// Get community tips for "Amira's Picks" section
  /// Returns motivational and technical tips from Amira Abdelsalam
  static List<TipModel> getTips() {
    return [
      const TipModel(
        id: 'tip_001',
        title: 'Focus on Logic First',
        content:
            'Don\'t worry about memorizing syntax. Focus on understanding the logic and problem-solving approach. Syntax comes naturally with practice.',
        author: 'Amira Abdelsalam',
        category: 'Learning',
      ),
      const TipModel(
        id: 'tip_002',
        title: 'Build Real Projects',
        content:
            'The best way to learn is by building. Start with small projects and gradually increase complexity. Each project teaches you something new.',
        author: 'Amira Abdelsalam',
        category: 'Practice',
      ),
      const TipModel(
        id: 'tip_003',
        title: 'Embrace Mistakes',
        content:
            'Every bug you encounter is a learning opportunity. Don\'t get frustrated - debugging makes you a better developer.',
        author: 'Amira Abdelsalam',
        category: 'Motivation',
      ),
      const TipModel(
        id: 'tip_004',
        title: 'Read Others\' Code',
        content:
            'Study open-source projects on GitHub. Reading well-written code is one of the fastest ways to improve your skills.',
        author: 'Amira Abdelsalam',
        category: 'Technical',
      ),
      const TipModel(
        id: 'tip_005',
        title: 'Consistency Over Intensity',
        content:
            '30 minutes of focused learning every day is better than 5 hours once a week. Build a sustainable learning habit.',
        author: 'Amira Abdelsalam',
        category: 'Motivation',
      ),
      const TipModel(
        id: 'tip_006',
        title: 'Ask for Help',
        content:
            'Don\'t spend hours stuck on a problem. Join developer communities, ask questions, and learn from others\' experiences.',
        author: 'Amira Abdelsalam',
        category: 'Career',
      ),
    ];
  }

  /// Get learning resources categorized by type
  /// Returns resources for problem solving, books, tools, and competitions
  static List<ResourceModel> getResources() {
    return [
      // Problem Solving Platforms
      const ResourceModel(
        id: 'ps_001',
        title: 'LeetCode',
        description:
            'Master coding interviews with 2000+ problems. Practice data structures, algorithms, and system design.',
        category: 'problem_solving',
        isFree: false, // Has free tier but premium is recommended
        url: 'https://leetcode.com',
      ),
      const ResourceModel(
        id: 'ps_002',
        title: 'HackerRank',
        description:
            'Improve your coding skills with challenges in algorithms, data structures, AI, and more.',
        category: 'problem_solving',
        isFree: true,
        url: 'https://www.hackerrank.com',
      ),
      const ResourceModel(
        id: 'ps_003',
        title: 'Codeforces',
        description:
            'Competitive programming platform with regular contests and a vast problem archive.',
        category: 'problem_solving',
        isFree: true,
        url: 'https://codeforces.com',
      ),
      const ResourceModel(
        id: 'ps_004',
        title: 'CodeChef',
        description:
            'Practice competitive programming with monthly contests and learning resources.',
        category: 'problem_solving',
        isFree: true,
        url: 'https://www.codechef.com',
      ),

      // Books
      const ResourceModel(
        id: 'book_001',
        title: 'Clean Code',
        description:
            'A handbook of agile software craftsmanship. Learn to write code that is easy to read and maintain.',
        category: 'books',
        isFree: false,
        author: 'Robert C. Martin',
      ),
      const ResourceModel(
        id: 'book_002',
        title: 'Grokking Algorithms',
        description:
            'An illustrated guide for programmers and curious readers. Makes complex algorithms easy to understand.',
        category: 'books',
        isFree: false,
        author: 'Aditya Bhargava',
      ),
      const ResourceModel(
        id: 'book_003',
        title: 'The Pragmatic Programmer',
        description:
            'Your journey to mastery. Timeless advice on software development and career growth.',
        category: 'books',
        isFree: false,
        author: 'David Thomas & Andrew Hunt',
      ),
      const ResourceModel(
        id: 'book_004',
        title: 'You Don\'t Know JS',
        description:
            'Deep dive into JavaScript core mechanisms. Free online book series for mastering JS.',
        category: 'books',
        isFree: true,
        author: 'Kyle Simpson',
        url: 'https://github.com/getify/You-Dont-Know-JS',
      ),

      // Tools
      const ResourceModel(
        id: 'tool_001',
        title: 'Git',
        description:
            'Distributed version control system. Essential for tracking code changes and collaboration.',
        category: 'tools',
        isFree: true,
        url: 'https://git-scm.com',
      ),
      const ResourceModel(
        id: 'tool_002',
        title: 'Postman',
        description:
            'API development and testing platform. Simplify API workflows and collaboration.',
        category: 'tools',
        isFree: false, // Has free tier
        url: 'https://www.postman.com',
      ),
      const ResourceModel(
        id: 'tool_003',
        title: 'Figma',
        description:
            'Collaborative interface design tool. Create, prototype, and share designs in real-time.',
        category: 'tools',
        isFree: false, // Has free tier
        url: 'https://www.figma.com',
      ),
      const ResourceModel(
        id: 'tool_004',
        title: 'Stack Overflow',
        description:
            'Q&A platform for developers. Find answers to coding questions and help others.',
        category: 'tools',
        isFree: true,
        url: 'https://stackoverflow.com',
      ),
      const ResourceModel(
        id: 'tool_005',
        title: 'VS Code',
        description:
            'Free, powerful code editor with extensions for every language and framework.',
        category: 'tools',
        isFree: true,
        url: 'https://code.visualstudio.com',
      ),

      // Competitions
      const ResourceModel(
        id: 'comp_001',
        title: 'ICPC',
        description:
            'International Collegiate Programming Contest. The oldest and most prestigious programming competition.',
        category: 'competitions',
        isFree: true,
        url: 'https://icpc.global',
      ),
      const ResourceModel(
        id: 'comp_002',
        title: 'Google Hash Code',
        description:
            'Team programming competition by Google. Solve real-world engineering problems.',
        category: 'competitions',
        isFree: true,
        url: 'https://codingcompetitions.withgoogle.com/hashcode',
      ),
      const ResourceModel(
        id: 'comp_003',
        title: 'Meta Hacker Cup',
        description:
            'Annual worldwide programming competition hosted by Meta. Win prizes and recognition.',
        category: 'competitions',
        isFree: true,
        url: 'https://www.facebook.com/codingcompetitions/hacker-cup',
      ),
      const ResourceModel(
        id: 'comp_004',
        title: 'Google Code Jam',
        description:
            'Algorithmic programming competition. Compete against the world\'s best programmers.',
        category: 'competitions',
        isFree: true,
        url: 'https://codingcompetitions.withgoogle.com/codejam',
      ),
    ];
  }

  /// Get available scholarships in Egypt
  /// Returns scholarship opportunities from ITI, NTI, and fwd
  static List<ResourceModel> getScholarships() {
    return [
      // ITI Scholarships
      const ResourceModel(
        id: 'scholarship_001',
        title: 'ITI 9-Month Professional Training Program',
        description:
            'Intensive 9-month program by the Information Technology Institute (ITI) offering professional training in software development, AI, cybersecurity, and more. Fully funded by the Egyptian government with job placement support.',
        category: 'scholarships',
        isFree: true,
        url: 'https://www.iti.gov.eg/',
      ),
      const ResourceModel(
        id: 'scholarship_002',
        title: 'ITI Intensive Code Camp',
        description:
            'Short-term intensive bootcamp (3-4 months) focused on practical coding skills. Covers web development, mobile development, and software engineering fundamentals. Free training with certification.',
        category: 'scholarships',
        isFree: true,
        url: 'https://www.iti.gov.eg/',
      ),

      // NTI Scholarships
      const ResourceModel(
        id: 'scholarship_003',
        title: 'NTI - Digital Egypt Youth Initiative (DEPI)',
        description:
            'National Telecommunication Institute program providing free digital skills training for Egyptian youth. Covers software development, data science, digital marketing, and emerging technologies with government certification.',
        category: 'scholarships',
        isFree: true,
        url: 'https://nti.sci.eg/',
      ),

      // fwd Scholarships
      const ResourceModel(
        id: 'scholarship_004',
        title: 'fwd - Udacity Nanodegree Scholarships',
        description:
            'Future Work is Digital (fwd) initiative offering fully-funded Udacity Nanodegree scholarships in partnership with the Egyptian government. Programs include AI, data analysis, web development, and digital marketing.',
        category: 'scholarships',
        isFree: true,
        url: 'https://egfwd.com/',
      ),
      const ResourceModel(
        id: 'scholarship_005',
        title: 'fwd - Advanced Professional Tracks',
        description:
            'Advanced scholarship tracks for experienced developers. Includes cloud computing, machine learning, full-stack development, and product management. Requires completion of assessment tests.',
        category: 'scholarships',
        isFree: true,
        url: 'https://egfwd.com/',
      ),
    ];
  }

  /// Get available mentors for booking sessions
  /// Returns mentors with expertise in various areas
  static List<MentorModel> getMentors() {
    return [
      // Featured Mentor - Amira Abdelsalam
      const MentorModel(
        id: 'mentor_001',
        name: 'Amira Abdelsalam',
        title: 'Senior Flutter Developer',
        company: 'Ex-Google',
        rating: 5.0,
        skills: ['Flutter', 'Dart', 'Architecture', 'Career Guidance'],
        hourlyRate: 80,
        badge: 'Top Mentor',
        avatarEmoji: '👩‍💻',
      ),

      const MentorModel(
        id: 'mentor_002',
        name: 'Ahmed Hassan',
        title: 'Mobile Architect',
        company: 'Meta',
        rating: 4.9,
        skills: ['System Design', 'Performance', 'CI/CD'],
        hourlyRate: 100,
        badge: 'Ex-Meta',
        avatarEmoji: '👨‍💼',
      ),

      const MentorModel(
        id: 'mentor_003',
        name: 'Sara Mohamed',
        title: 'Full Stack Developer',
        company: 'Microsoft',
        rating: 4.8,
        skills: ['Backend', 'APIs', 'Database Design'],
        hourlyRate: 75,
        avatarEmoji: '👩‍🔬',
      ),

      const MentorModel(
        id: 'mentor_004',
        name: 'Omar Khaled',
        title: 'Tech Lead',
        company: 'Amazon',
        rating: 4.9,
        skills: ['Leadership', 'Agile', 'Team Management'],
        hourlyRate: 90,
        badge: 'Top Rated',
        avatarEmoji: '👨‍🏫',
      ),

      const MentorModel(
        id: 'mentor_005',
        name: 'Nour Ali',
        title: 'UI/UX Engineer',
        company: 'Figma',
        rating: 4.7,
        skills: ['Design Systems', 'Animations', 'Accessibility'],
        hourlyRate: 70,
        avatarEmoji: '👩‍🎨',
      ),

      const MentorModel(
        id: 'mentor_006',
        name: 'Youssef Ibrahim',
        title: 'DevOps Engineer',
        company: 'AWS',
        rating: 4.8,
        skills: ['Cloud', 'Docker', 'Kubernetes', 'Monitoring'],
        hourlyRate: 85,
        badge: 'Cloud Expert',
        avatarEmoji: '👨‍🔧',
      ),
    ];
  }
}

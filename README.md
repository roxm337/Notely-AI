# Notely AI

Notely AI is a modern note-taking application with AI-powered features, built using Flutter. It combines the simplicity of note-taking with the power of artificial intelligence to help you organize and manage your notes more effectively.

## Features

### 📝 Note Management
- Create, edit, and delete notes
- Beautiful card-based UI with grid and list views
- Rich text formatting
- Note categorization with tags
- Favorite notes for quick access
- Search functionality
- Timestamp tracking

### 🤖 AI Integration
- AI-powered chat assistant
- Smart note analysis
- Context-aware responses
- Natural language processing
- Intelligent note suggestions

### 🎨 Modern UI/UX
- Material Design 3
- Dark/Light theme support
- Responsive layout
- Smooth animations
- Intuitive navigation
- Beautiful gradients and visual effects

### 🔒 Security
- Encrypted note storage
- Secure data handling
- Privacy-focused design

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
│   ├── note.dart            # Note model
│   └── message.dart         # Chat message model
├── providers/               # State management
│   ├── notes_provider.dart  # Notes state management
│   └── chat_provider.dart   # Chat state management
├── screens/                 # UI screens
│   ├── home_screen.dart     # Main notes screen
│   └── chat_screen.dart     # AI chat interface
├── services/               # Business logic
│   └── ai_service.dart     # AI integration service
└── widgets/               # Reusable UI components
```

## Key Components

### Models
- `Note`: Represents a note with title, content, and metadata
- `Message`: Represents a chat message in the AI conversation

### Providers
- `NotesProvider`: Manages note state and operations
- `ChatProvider`: Handles chat history and AI interactions

### Screens
- `HomeScreen`: Main interface for note management
- `ChatScreen`: AI chat interface for note assistance

### Services
- `AIService`: Handles AI integration and note analysis

## Getting Started

### Prerequisites
- Flutter SDK (latest version)
- Dart SDK (latest version)
- Google AI API key

### Installation
1. Clone the repository
```bash
git clone https://github.com/roxm337/notely_ai.git
```

2. Install dependencies
```bash
flutter pub get
```

3. Create a `.env` file in the root directory and add your API key
```
GOOGLE_AI_API_KEY=your_api_key_here
```

4. Run the app
```bash
flutter run
```

## Dependencies

- `flutter`: UI framework
- `provider`: State management
- `hive`: Local storage
- `google_generative_ai`: AI integration
- `flutter_markdown`: Markdown rendering
- `flutter_staggered_grid_view`: Grid layout
- `encrypt`: Data encryption
- `flutter_dotenv`: Environment variables



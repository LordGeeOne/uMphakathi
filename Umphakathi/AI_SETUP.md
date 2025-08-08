# AI Configuration Setup

## Setting up Gemini AI

To enable the AI companion with real Gemini AI responses, you need to:

### 1. Get a Gemini API Key
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy your API key

### 2. Configure the API Key
1. Open `lib/services/gemini_service.dart`
2. Replace `'YOUR_GEMINI_API_KEY_HERE'` with your actual API key:
   ```dart
   static const String _apiKey = 'your-actual-api-key-here';
   ```

### 3. Install Dependencies
Run the following command in your project directory:
```bash
flutter pub get
```

### 4. Test the AI
- The AI companion will show "Online" when properly configured
- If the API key is not set, it will show "Offline Mode" and use fallback responses
- The AI is specifically tuned for mental health support and safety

## Features

### AI Capabilities:
- **Emotional Support**: Provides empathetic responses to mental health concerns
- **Crisis Recognition**: Identifies potential crisis situations and provides resources
- **Cultural Awareness**: Tailored for South African context and resources
- **Privacy-Focused**: Conversations are private between user and AI
- **Contextual Memory**: Remembers conversation context for better responses

### Safety Features:
- **Crisis Resources**: Includes South African emergency numbers and helplines
- **Professional Boundaries**: Clearly states it's not a replacement for professional help
- **Harm Prevention**: Trained to recognize and respond to self-harm indicators

## Privacy & Security

- All conversations are processed through Google's Gemini API
- No conversation data is stored locally beyond the current session
- API calls are made securely over HTTPS
- Consider privacy implications when deploying to production

## Fallback Mode

When the API is unavailable or not configured:
- The app automatically switches to "Offline Mode"
- Provides intelligent keyword-based responses
- Maintains supportive conversation flow
- No functionality is lost, just reduced AI sophistication

## Cost Considerations

- Gemini API has a generous free tier
- Monitor usage in Google AI Studio
- Consider implementing rate limiting for production apps
- Each message counts as one API request

import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyB8Ife7Sz1u6cf3Xm3UwUfxrBi8R7EL5O8';
  late final GenerativeModel _model;
  late final ChatSession _chat;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system('''
You are a compassionate, supportive AI companion for the Umphakathi safety app. Your role is to:

1. Provide emotional support and mental health guidance
2. Listen empathetically to users' concerns
3. Offer practical coping strategies and resources
4. Help users track their wellbeing
5. Recognize signs of crisis and provide appropriate resources

Guidelines:
- Always be empathetic, non-judgmental, and supportive
- Use a warm, caring tone while remaining professional
- Provide actionable advice when appropriate
- Respect cultural sensitivity, especially South African context
- If someone expresses serious harm to self/others, provide crisis resources
- Keep responses concise but meaningful (2-4 sentences typically)
- Remember previous conversation context
- Focus on empowerment and resilience building

Safety Resources (South Africa):
- Emergency: 10111 (Police), 10177 (Medical)
- Suicide Crisis Line: 0800 567 567
- Depression & Anxiety Support: 011 262 6396
- Gender-Based Violence: 0800 428 428

Remember: You're not a replacement for professional help, but a supportive companion.
      '''),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 500,
      ),
    );
    
    _chat = _model.startChat();
  }

  Future<String> sendMessage(String message) async {
    try {
      final content = Content.text(message);
      final response = await _chat.sendMessage(content);
      
      return response.text ?? 'I apologize, but I\'m having trouble responding right now. Please try again.';
    } catch (e) {
      print('Gemini API Error: $e');
      
      // Fallback to local responses if API fails
      return _getFallbackResponse(message.toLowerCase());
    }
  }

  String _getFallbackResponse(String message) {
    // Enhanced fallback responses when API is unavailable
    if (message.contains('sad') || message.contains('down') || message.contains('depressed')) {
      return "I'm sorry you're feeling this way. It's completely normal to have difficult days. Would you like to talk about what's making you feel sad? Sometimes sharing can help lighten the burden. 💙";
    } else if (message.contains('anxious') || message.contains('worried') || message.contains('stress')) {
      return "Anxiety can be overwhelming, but you're taking a positive step by acknowledging it. Try taking a few deep breaths with me: in for 4, hold for 4, out for 6. What specifically is causing you anxiety right now?";
    } else if (message.contains('angry') || message.contains('mad') || message.contains('frustrated')) {
      return "Feeling angry is a natural emotion that often signals something important to you has been affected. Let's work through this together. What triggered these feelings?";
    } else if (message.contains('happy') || message.contains('good') || message.contains('great') || message.contains('wonderful')) {
      return "I'm so glad to hear you're feeling positive! 😊 It's wonderful when we can recognize and appreciate the good moments. What's contributing to your happiness today?";
    } else if (message.contains('tired') || message.contains('exhausted') || message.contains('sleep')) {
      return "Feeling tired can affect everything in our lives. Are you getting enough rest? Sometimes fatigue can also be emotional. Have you been taking care of your basic needs lately?";
    } else if (message.contains('help') || message.contains('support') || message.contains('crisis')) {
      return "I'm here to support you. If you're in immediate danger, please contact emergency services (10111). For crisis support, call 0800 567 567. What kind of support would be most helpful right now?";
    } else if (message.contains('lonely') || message.contains('alone') || message.contains('isolated')) {
      return "Feeling lonely can be really difficult. You're not alone in this feeling, and reaching out here shows strength. Connection is so important - are there small ways you could reach out to others today?";
    } else if (message.contains('work') || message.contains('job') || message.contains('career')) {
      return "Work-related stress is very common. It's important to find balance and remember that your worth isn't defined by work alone. What aspect of work is challenging you most right now?";
    } else if (message.contains('relationship') || message.contains('family') || message.contains('friend')) {
      return "Relationships can be complex and emotionally challenging. It's natural to have ups and downs with the people we care about. What's happening in your relationships that you'd like to talk about?";
    } else if (message.contains('thank') || message.contains('grateful') || message.contains('appreciate')) {
      return "You're so welcome! It means a lot that our conversation is helpful. Expressing gratitude, even in difficult times, shows real emotional strength. How are you taking care of yourself today?";
    } else {
      return "Thank you for sharing that with me. Your feelings and experiences are completely valid. I'm here to listen and support you through whatever you're going through. How does expressing this make you feel?";
    }
  }

  void resetChat() {
    _chat = _model.startChat();
  }

  // Method to check if API key is properly configured
  bool get isConfigured => _apiKey != 'YOUR_GEMINI_API_KEY_HERE' && _apiKey.isNotEmpty;
}

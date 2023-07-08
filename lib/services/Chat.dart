import 'package:flutter/material.dart';

class ChatbotApp extends StatefulWidget {
  static String id = 'ChatbotApp';
  @override
  _ChatbotAppState createState() => _ChatbotAppState();
}

class _ChatbotAppState extends State<ChatbotApp> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textEditingController = TextEditingController();

  void _handleSubmitted(String text) {
    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUserMessage: true));
      _textEditingController.clear();
    });

    // Process the user's message and generate a response
    String response = generateResponse(text);

    // Simulate a delay before showing the response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.insert(0, ChatMessage(text: response, isUserMessage: false));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, index) => _messages[index],
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textEditingController,
                onSubmitted: _handleSubmitted,
                decoration:
                    const InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textEditingController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;

  const ChatMessage({required this.text, this.isUserMessage = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          // Container(
          //   margin: const EdgeInsets.only(right: 16.0),
          //   child: CircleAvatar(child: Text(isUserMessage ? 'User' : 'Bot')),
          // ),
          Expanded(
            child: Column(
              crossAxisAlignment: isUserMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: Text(
                    isUserMessage ? 'You' : 'Bot',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0, left: 10, right: 10),
                  child: Text(text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String generateResponse(String message) {
  // Simple response generation logic
  if (message.toLowerCase().contains('hello') ||
      message.toLowerCase().contains('hi')) {
    return 'Hello! How can I assist you?';
  } else if (message.toLowerCase().contains('bye')) {
    return 'Goodbye! Have a nice day!';
  } else {
    return "I'm sorry, I didn't understand that. I am still unter training";
  }
}

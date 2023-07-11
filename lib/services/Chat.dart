import 'package:flutter/material.dart';

class ChatbotApp extends StatefulWidget {
  static String id = 'ChatbotApp';

  const ChatbotApp({super.key});
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
                    isUserMessage ? 'You' : 'iwashhub',
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
  } else if (message.toLowerCase().contains('stain')) {
    return 'For stain removal, it is best to treat the stain as soon as possible. Different types of stains require different treatments.';
  } else if (message.toLowerCase().contains('detergent')) {
    return 'There are many types of laundry detergents available, including liquid, powder, and single-dose pods. Choose one that is appropriate for your washing machine and the type of clothes you are washing.';
  } else if (message.toLowerCase().contains('bleach')) {
    return 'Bleach can be used to whiten and brighten clothes, as well as remove stains. However, it should only be used on white or colorfast fabrics.';
  } else if (message.toLowerCase().contains('fabric softener')) {
    return 'Fabric softener can be added to the rinse cycle to make clothes feel softer and reduce static cling. However, it should not be used on certain fabrics such as microfiber or sportswear.';
  } else if (message.toLowerCase().contains('dry cleaning')) {
    return 'Dry cleaning is a professional cleaning process that uses solvents instead of water to clean clothes. It is recommended for delicate or special care items.';
  } else if (message.toLowerCase().contains('hand washing')) {
    return 'Hand washing is a gentle way to clean delicate or special care items. Use cool water and a mild detergent, and gently agitate the clothes before rinsing thoroughly.';
  } else if (message.toLowerCase().contains('ironing')) {
    return 'Ironing can help remove wrinkles and give clothes a crisp, neat appearance. Use the appropriate heat setting for the fabric, and iron in a back-and-forth motion.';
  } else if (message.toLowerCase().contains('sorting laundry')) {
    return 'Sorting laundry before washing can help prevent colors from bleeding and ensure that clothes are washed in the appropriate cycle. Sort by color, fabric type, and level of soil.';
  } else if (message.toLowerCase().contains('washing machine')) {
    return 'A washing machine is a convenient way to clean clothes. Choose the appropriate cycle, water temperature, and detergent for the load.';
  } else if (message.toLowerCase().contains('drying clothes')) {
    return 'Clothes can be dried in a dryer or hung up to air dry. Choose the appropriate method based on the fabric type and care instructions.';
  } else if (message.toLowerCase().contains('fold')) {
    return 'Folding clothes neatly can help prevent wrinkles and make them easier to store. Smooth out any wrinkles before folding, and fold in a consistent manner.';
  } else if (message.toLowerCase().contains('hang')) {
    return 'Hanging clothes can help prevent wrinkles and keep them looking neat. Use the appropriate type of hanger for the garment, and hang in a well-ventilated area.';
  } else if (message.toLowerCase().contains('storing clothes')) {
    return 'Storing clothes properly can help keep them looking their best. Fold or hang clothes neatly, and store in a cool, dry place away from direct sunlight.';
  } else if (message.toLowerCase().contains('remove lint')) {
    return 'Lint can be removed from clothes using a lint roller or brush. Gently roll or brush over the affected area to remove lint.';
  } else if (message.toLowerCase().contains('remove pills')) {
    return 'Pills are small balls of fiber that can form on the surface of fabrics. They can be removed using a fabric shaver or by carefully snipping them off with scissors.';
  } else if (message.toLowerCase().contains('remove odors')) {
    return 'Odors can be removed from clothes by laundering them with an odor-eliminating detergent or by airing them out in a well-ventilated area.';
  } else if (message.toLowerCase().contains('washing delicates')) {
    return 'Delicate items should be washed carefully to prevent damage. Hand wash or use a gentle cycle on the washing machine, and use a mild detergent.';
  } else if (message.toLowerCase().contains('white')) {
    return 'White clothes should be washed separately from colored clothes to prevent discoloration. Use a laundry detergent with bleach or bleach alternative to help keep whites bright.';
  } else if (message.toLowerCase().contains('colors')) {
    return 'Colored clothes should be washed separately from whites to prevent bleeding. Use a color-safe detergent and wash in cool water to help prevent fading.';
  } else if (message.toLowerCase().contains('washing darks')) {
    return 'Dark clothes should be washed separately from light-colored clothes to prevent bleeding. Turn dark items inside out before washing to help prevent fading.';
  } else if (message.toLowerCase().contains('wrinkles')) {
    return 'Wrinkles can be removed from clothes by ironing, steaming, or using a wrinkle-release spray. Choose the appropriate method based on the fabric type and care instructions.';
  } else if (message.toLowerCase().contains('pet hair')) {
    return 'Pet hair can be removed from clothes using a lint roller, brush, or damp cloth. Gently roll or brush over the affected area to remove pet hair.';
  } else if (message.toLowerCase().contains('static cling')) {
    return 'Static cling can be reduced by using fabric softener, dryer sheets, or a humidifier. Choose the appropriate method based on the fabric type and care instructions.';
  } else if (message.toLowerCase().contains('bed linens')) {
    return 'Bed linens should be washed regularly to keep them clean and fresh. Use a laundry detergent appropriate for the fabric type, and wash in warm or hot water if possible.';
  } else if (message.toLowerCase().contains('towels')) {
    return 'Towels should be washed regularly to keep them clean and fresh. Use a laundry detergent with bleach or bleach alternative to help remove any odors or stains.';
  } else if (message.toLowerCase().contains('jeans')) {
    return 'Jeans can be washed in the washing machine on a cold or warm cycle. Turn them inside out before washing to help prevent fading, and avoid using fabric softener.';
  } else if (message.toLowerCase().contains('wool')) {
    return 'Wool items should be washed carefully to prevent shrinkage or damage. Hand wash or use a gentle cycle on the washing machine, and use a detergent specifically designed for wool.';
  } else if (message.toLowerCase().contains('silk')) {
    return 'Silk items should be washed carefully to prevent damage. Hand wash or use a gentle cycle on the washing machine, and use a detergent specifically designed for silk.';
  } else if (message.toLowerCase().contains('cashmere')) {
    return 'Cashmere items should be washed carefully to prevent shrinkage or damage. Hand wash or use a gentle cycle on the washing machine, and use a detergent specifically designed for cashmere.';
  } else if (message.toLowerCase().contains('cotton')) {
    return 'Cotton items can be washed in the washing machine on a warm or hot cycle. Use a laundry detergent appropriate for the fabric type and level of soil.';
  } else if (message.toLowerCase().contains('linen')) {
    return 'Linen items can be washed in the washing machine on a warm or hot cycle. Use a laundry detergent appropriate for the fabric type and level of soil.';
  } else if (message.toLowerCase().contains('polyester')) {
    return 'Polyester items can be washed in the washing machine on a warm or hot cycle. Use a laundry detergent appropriate for the fabric type and level of soil.';
  } else if (message.toLowerCase().contains('rayon')) {
    return 'Rayon items should be washed carefully to prevent shrinkage or damage. Hand wash or use a gentle cycle on the washing machine, and use a mild detergent.';
  } else if (message.toLowerCase().contains('nylon')) {
    return 'Nylon items can be washed in the washing machine on a warm or hot cycle. Use a laundry detergent appropriate for the fabric type and level of soil.';
  } else if (message.toLowerCase().contains('spandex')) {
    return 'Spandex items should be washed carefully to prevent damage. Hand wash or use a gentle cycle on the washing machine, and use a mild detergent.';
  } else if (message.toLowerCase().contains('leather')) {
    return 'Leather items should not be washed in water as it can cause damage. Instead, clean them using a leather cleaner and conditioner according to the manufacturers instructions.';
  } else if (message.toLowerCase().contains('suede')) {
    return 'Suede items should not be washed in water as it can cause damage. Instead, clean them using a suede cleaner and brush according to the manufacturers instructions.';
  } else if (message.toLowerCase().contains('blood stains')) {
    return 'Blood stains can be difficult to remove once they have set. Rinse the stain in cold water as soon as possible, then treat with an enzyme-based stain remover before laundering as usual.';
  } else if (message.toLowerCase().contains('grass stains')) {
    return 'Grass stains can be difficult to remove once they have set. Treat the stain with an enzyme-based stain remover before laundering as usual.';
  } else if (message.toLowerCase().contains("swimwear")) {
    return "Swimwear should be washed after each use to remove chlorine and other chemicals. Hand wash with a mild detergent, and avoid wringing or twisting the fabric.";
  } else if (message.toLowerCase().contains("activewear")) {
    return "Activewear should be washed after each use to remove sweat and odor. Use a detergent designed for activewear, and wash in cool water to help maintain elasticity.";
  } else if (message.toLowerCase().contains("baby")) {
    return "Baby clothes should be washed separately from adult clothes to prevent cross-contamination. Use a gentle detergent that is free from fragrances and dyes.";
  } else if (message.toLowerCase().contains("synthetic fabrics")) {
    return "Synthetic fabrics can be washed in the washing machine on a gentle cycle. Use a mild detergent and avoid using fabric softener to maintain the fabric's properties.";
  } else if (message.toLowerCase().contains("linen-blend fabrics")) {
    return "Linen-blend fabrics should be washed according to the care instructions on the garment. Some blends can be machine washed, while others may require hand washing.";
  } else if (message.toLowerCase().contains("delicate embellishments")) {
    return "Garments with delicate embellishments should be washed carefully to avoid damaging the decorations. Hand wash or use a gentle cycle, and avoid rubbing or scrubbing the embellishments.";
  } else if (message.toLowerCase().contains("vintage clothing")) {
    return "Vintage clothing often requires special care. Check the care instructions or consult with a professional cleaner to determine the best cleaning method for each garment.";
  } else if (message.toLowerCase().contains("ink stains")) {
    return "Ink stains can be challenging to remove. Blot the stain with a clean cloth to remove excess ink, then treat with an ink stain remover or rubbing alcohol before laundering.";
  } else if (message.toLowerCase().contains("oil stains")) {
    return "Oil stains can be tricky to remove. Apply a pre-treatment stain remover or liquid detergent directly to the stain, then wash in the hottest water allowed for the fabric.";
  } else if (message.toLowerCase().contains("wine stains")) {
    return "Wine stains should be treated as soon as possible. Blot the stain with a clean cloth to absorb excess liquid, then apply a stain remover or a mixture of dish soap and hydrogen peroxide before laundering.";
  } else {
    return "I'm sorry, I didn't understand that. I am still under training";
  }
}

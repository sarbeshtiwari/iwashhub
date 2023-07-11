import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class HelpSupport extends StatelessWidget {
  const HelpSupport({super.key});
  static const String id = "Help-Support";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: const Text(
            "Help & support",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GFAccordion(
                title: "What is the usual turnaround time?",
                content:
                    "We take 24 to 72 hours depending on the service, you are looking for. You can also opt for express delivery in case of emergency.",
                titleBorderRadius: BorderRadius.all(Radius.circular(10)),
                contentBorderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              GFAccordion(
                title: "How to reschedule a missed order?",
                content:
                    "If in case you miss your order, you can reschedule it by calling at +91 894-831-0077 , and we will reschedule it. You may also do it online through website or mobile App.",
                titleBorderRadius: BorderRadius.all(Radius.circular(10)),
                contentBorderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              GFAccordion(
                title: "How to contact iWash Hub in case of a query/complaint?",
                content:
                    "You can contact us at +91 894-831-0077or write to us at info@iwashhub.com . We will be more than happy to resolve it.",
                titleBorderRadius: BorderRadius.all(Radius.circular(10)),
                contentBorderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              GFAccordion(
                title: "How can I schedule my service with iWash Hub ?",
                content:
                    "An order can be scheduled through iWash Hub mobile application, website, or by calling at +91 894-831-0077. You can also visit to the nearest iWash Hub store.",
                titleBorderRadius: BorderRadius.all(Radius.circular(10)),
                contentBorderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              GFAccordion(
                title: "What is the minimum order value?",
                content:
                    "Our Minimum order value is Rs 250. You can also visit our live laundry and dryclean store to avoid minimum order amount.",
                titleBorderRadius: BorderRadius.all(Radius.circular(10)),
                contentBorderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              GFAccordion(
                title: "Which chemical and detergent are used in cleaning? ",
                content:
                    "We only use the quality and best in a class detergent brand like Xtreme chemicals ( Made specifically for Professional Laundry.",
                titleBorderRadius: BorderRadius.all(Radius.circular(10)),
                contentBorderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              GFAccordion(
                title: "Are their things that you will not Clean?",
                content:
                    "We are a one-stop cleaning company providing you with all possible services connected with Laundry, Dry-cleaning, Steam ironing and Shoe & Backpack Laundry. Our portfolio is limited to these areas as of now. However, in future, we would introduce more and more innovative services, and we will keep you posted. ",
                titleBorderRadius: BorderRadius.all(Radius.circular(10)),
                contentBorderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              GFAccordion(
                title: "How do I give special instructions for my service? ",
                content:
                    "We take necessary inputs/ instructions from you while you book a service from our website, mobile App and phone call. We inform you at the point of booking the order if that is possible for us to adhere to.",
                titleBorderRadius: BorderRadius.all(Radius.circular(10)),
                contentBorderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              GFAccordion(
                title: "How do I make payment?",
                content:
                    "We accept cash, card, UPI, wallet and other online methods. You can make payment through our website, our mobile App, payment link.",
                titleBorderRadius: BorderRadius.all(Radius.circular(10)),
                contentBorderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              GFAccordion(
                title: "Do I need to tip the partner?",
                content:
                    "There is no need to stress your pockets for that extra bit; we motivate our boys with ample incentives! Words like Thank you or a compliment from your side is good enough to raise the spirit of your laundry boy.",
                titleBorderRadius: BorderRadius.all(Radius.circular(10)),
                contentBorderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              GFAccordion(
                title: "How do I avail discounts?",
                content:
                    "Every discounts/Offers is always displaced on the website or App in the 'promotion page'. Also, keep checking your inbox regularly for our exciting offers. ",
                titleBorderRadius: BorderRadius.all(Radius.circular(10)),
                contentBorderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ],
          ),
        ));
  }
}

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';

class CallPanel extends StatelessWidget {
  final bool viewPanel;
  final List<String> infoStrings;

  const CallPanel(
      {super.key, required this.infoStrings, required this.viewPanel});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Visibility(
        visible: viewPanel,
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: FractionallySizedBox(
            heightFactor: 0.5,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: ListView.builder(
                itemCount: infoStrings.length,
                reverse: true,
                itemBuilder: (context, index) {
                  if (infoStrings.isEmpty) {
                    return const Text("No Realtime status messages");
                  }
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            infoStrings[index],
                            style: const TextStyle(color: Colors.blueGrey),
                          ),
                        ))
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }
}

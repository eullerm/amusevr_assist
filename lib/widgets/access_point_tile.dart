import 'package:amusevr_assist/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';

import 'package:wifi_scan/wifi_scan.dart';

class AccessPointTile extends StatelessWidget {
  final WiFiAccessPoint accessPoint;
  final Function() onConfirm;

  const AccessPointTile({Key? key, required this.onConfirm, required this.accessPoint}) : super(key: key);

  Widget _buildInfo(String label, dynamic value) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value.toString()))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = accessPoint.ssid.isNotEmpty ? accessPoint.ssid : "**EMPTY**";
    final signalIcon = accessPoint.level >= -80 ? Icons.signal_wifi_4_bar : Icons.signal_wifi_0_bar;
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Icon(signalIcon),
      title: Text(title),
      subtitle: Text(accessPoint.capabilities),
      onTap: () => showDialog(
        context: context,
        builder: (context) => CustomDialog(
          title: title,
          items: {
            "BSSDI": accessPoint.bssid,
            "Capability": accessPoint.capabilities,
            "frequency": "${accessPoint.frequency}MHz",
            "level": accessPoint.level,
            "standard": accessPoint.standard,
            "centerFrequency0": "${accessPoint.centerFrequency0}MHz",
            "centerFrequency1": "${accessPoint.centerFrequency1}MHz",
            "channelWidth": accessPoint.channelWidth,
            "isPasspoint": accessPoint.isPasspoint,
            "operatorFriendlyName": accessPoint.operatorFriendlyName,
            "venueName": accessPoint.venueName,
            "is80211mcResponder": accessPoint.is80211mcResponder
          },
          onConfirm: onConfirm,
        ),
      ),
    );
  }
}

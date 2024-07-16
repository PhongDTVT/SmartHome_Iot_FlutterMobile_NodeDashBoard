import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

import 'config/mqtt_config.dart';

class LiveStreamCamera extends StatefulWidget{
  const LiveStreamCamera({super.key});

  @override
  State<LiveStreamCamera> createState() => _LiveStreamCamera();
}

class _LiveStreamCamera extends State<LiveStreamCamera>{
  bool isPlaying = false;
  MQTTManager client = MQTTManager();



  final VlcPlayerController _camera = VlcPlayerController.network(
    'rtsp://192.168.1.7:8554/stream',
    hwAcc: HwAcc.full,
    autoPlay: true,
    options: VlcPlayerOptions(
      advanced: VlcAdvancedOptions([
      VlcAdvancedOptions.networkCaching(2000), // Tăng bộ đệm mạng
    ]),
    rtp: VlcRtpOptions([
      VlcRtpOptions.rtpOverRtsp(true),
      // Sử dụng RTP qua RTSP
    ]),
    )
  );





  @override
  void initState() {
    // TODO: implement initState


    client.connect('');
    super.initState();
  }

  void _toggleStream() {

    // if (!isPlaying) {
    //   _camera.stop();
    // } else {
    //   _camera.play();
    // }

    setState(() {
      isPlaying = !isPlaying;
      if(isPlaying){
        _camera.play();
        client.publishMessage("home/camera", "{\"stream_status\": 1}");
      }
      else{
        _camera.stop();
        client.publishMessage("home/camera", "{\"stream_status\": 0}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(isPlaying)
          VlcPlayer(
            controller: _camera,
            aspectRatio: 16/9,
            placeholder: const Center(
              child: CircularProgressIndicator(),
            ),
           ),


          ElevatedButton(
            onPressed: _toggleStream,
            child: Text(isPlaying ? 'Stop Stream' : 'Start Stream'),
          ),
        ],
      ),
    );
  }

  
}
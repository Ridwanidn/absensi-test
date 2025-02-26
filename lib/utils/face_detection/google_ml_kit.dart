import 'package:attendence_app/utils/face_detection/vision.dart';

// Face recognition using Google ML Kit
class GoogleMlKit {
  GoogleMlKit._();

  static final Vision vision = Vision.instance;
}
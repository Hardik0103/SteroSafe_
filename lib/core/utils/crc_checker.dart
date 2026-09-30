/// CRC-16-CCITT (Polynomial 0x1021, Init 0xFFFF)
/// Used for hardware packet integrity verification over Qualcomm Snapdragon Wear
/// sensor SPI/I2C/BLE telemetry streams.
class CrcChecker {
  static const int _polynomial = 0x1021;
  static const int _initialValue = 0xFFFF;

  /// Computes CRC-16 for the given byte buffer.
  static int computeCrc16(List<int> bytes) {
    int crc = _initialValue;
    for (int b in bytes) {
      crc ^= (b & 0xFF) << 8;
      for (int i = 0; i < 8; i++) {
        if ((crc & 0x8000) != 0) {
          crc = ((crc << 1) ^ _polynomial) & 0xFFFF;
        } else {
          crc = (crc << 1) & 0xFFFF;
        }
      }
    }
    return crc & 0xFFFF;
  }

  /// Verifies if the computed CRC matches the expected CRC.
  static bool verifyChecksum(List<int> bytes, int expectedCrc) {
    if (bytes.isEmpty) return false;
    final int computed = computeCrc16(bytes);
    return computed == (expectedCrc & 0xFFFF);
  }
}

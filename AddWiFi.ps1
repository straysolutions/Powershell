﻿$base64 = "PD94bWwgdmVyc2lvbj0iMS4wIj8+DQo8V0xBTlByb2ZpbGUgeG1sbnM9Imh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9uZXR3b3JraW5nL1dMQU4vcHJvZmlsZS92MSI+DQoJPG5hbWU+QWNjZXNzLVByaXZhdGUtUTM8L25hbWU+DQoJPFNTSURDb25maWc+DQoJCTxTU0lEPg0KCQkJPGhleD40MTYzNjM2NTczNzMyZDUwNzI2OTc2NjE3NDY1MmQ1MTMxPC9oZXg+DQoJCQk8bmFtZT5BY2Nlc3MtUHJpdmF0ZS1RMzwvbmFtZT4NCgkJPC9TU0lEPg0KCTwvU1NJRENvbmZpZz4NCgk8Y29ubmVjdGlvblR5cGU+RVNTPC9jb25uZWN0aW9uVHlwZT4NCgk8Y29ubmVjdGlvbk1vZGU+YXV0bzwvY29ubmVjdGlvbk1vZGU+DQoJPE1TTT4NCgkJPHNlY3VyaXR5Pg0KCQkJPGF1dGhFbmNyeXB0aW9uPg0KCQkJCTxhdXRoZW50aWNhdGlvbj5XUEEyUFNLPC9hdXRoZW50aWNhdGlvbj4NCgkJCQk8ZW5jcnlwdGlvbj5BRVM8L2VuY3J5cHRpb24+DQoJCQkJPHVzZU9uZVg+ZmFsc2U8L3VzZU9uZVg+DQoJCQk8L2F1dGhFbmNyeXB0aW9uPg0KCQkJPHNoYXJlZEtleT4NCgkJCQk8a2V5VHlwZT5wYXNzUGhyYXNlPC9rZXlUeXBlPg0KCQkJCTxwcm90ZWN0ZWQ+ZmFsc2U8L3Byb3RlY3RlZD4NCgkJCQk8a2V5TWF0ZXJpYWw+QklHT0xraXR0aWVzPC9rZXlNYXRlcmlhbD4NCgkJCTwvc2hhcmVkS2V5Pg0KCQk8L3NlY3VyaXR5Pg0KCTwvTVNNPg0KCTxNYWNSYW5kb21pemF0aW9uIHhtbG5zPSJodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vbmV0d29ya2luZy9XTEFOL3Byb2ZpbGUvdjMiPg0KCQk8ZW5hYmxlUmFuZG9taXphdGlvbj5mYWxzZTwvZW5hYmxlUmFuZG9taXphdGlvbj4NCgk8L01hY1JhbmRvbWl6YXRpb24+DQo8L1dMQU5Qcm9maWxlPg0K"

$Content = [System.Convert]::FromBase64String($Base64)
Set-Content -Path C:\Temp\WifiProfiletest.xml -Value $Content -Encoding Byte

netsh wlan add profile filename=C:\Temp\WifiProfile.xml

Remove-Item C:\Temp\WifiProfile.xml
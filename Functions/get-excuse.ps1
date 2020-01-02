function Get-Excuse {

    
$excuses = 'CD-ROM server needs recalibration','firewall needs cooling','Elves on strike','Your processor does not develop enough heat.','The rubber band broke','the daemons! the daemons! the terrible daemons!','its an ID-10-T error','DNS server drank too much and had a hiccup','Your Flux Capacitor has gone bad.','The mouse escaped','You did wha.... oh dear!','Daemons loose in system.','It was North Korea','Blame the Russians','Mouse chewed through power cable','Support staff hung over, send aspirin and come back LATER.','Satan did it','Windows undocumented feature','Bogons reading poetry killed the system','User attempted to devide by zero','I T half day','I blame Jenn','You put the disk in upside down.','China stole the data'

Add-Type -AssemblyName System.speech
Add-Type -TypeDefinition @'
using System.Runtime.InteropServices;

[Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IAudioEndpointVolume {
  // f(), g(), ... are unused COM method slots. Define these if you care
  int f(); int g(); int h(); int i();
  int SetMasterVolumeLevelScalar(float fLevel, System.Guid pguidEventContext);
  int j();
  int GetMasterVolumeLevelScalar(out float pfLevel);
  int k(); int l(); int m(); int n();
  int SetMute([MarshalAs(UnmanagedType.Bool)] bool bMute, System.Guid pguidEventContext);
  int GetMute(out bool pbMute);
}
[Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDevice {
  int Activate(ref System.Guid id, int clsCtx, int activationParams, out IAudioEndpointVolume aev);
}
[Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDeviceEnumerator {
  int f(); // Unused
  int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice endpoint);
}
[ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumeratorComObject { }

public class Audio {
  static IAudioEndpointVolume Vol() {
    var enumerator = new MMDeviceEnumeratorComObject() as IMMDeviceEnumerator;
    IMMDevice dev = null;
    Marshal.ThrowExceptionForHR(enumerator.GetDefaultAudioEndpoint(/*eRender*/ 0, /*eMultimedia*/ 1, out dev));
    IAudioEndpointVolume epv = null;
    var epvid = typeof(IAudioEndpointVolume).GUID;
    Marshal.ThrowExceptionForHR(dev.Activate(ref epvid, /*CLSCTX_ALL*/ 23, 0, out epv));
    return epv;
  }
  public static float Volume {
    get {float v = -1; Marshal.ThrowExceptionForHR(Vol().GetMasterVolumeLevelScalar(out v)); return v;}
    set {Marshal.ThrowExceptionForHR(Vol().SetMasterVolumeLevelScalar(value, System.Guid.Empty));}
  }
  public static bool Mute {
    get { bool mute; Marshal.ThrowExceptionForHR(Vol().GetMute(out mute)); return mute; }
    set { Marshal.ThrowExceptionForHR(Vol().SetMute(value, System.Guid.Empty)); }
  }
}
'@

# Collect current settings
$cur_mute  = [Audio]::Mute
$cur_audio = [Audio]::Volume 

# Disables Mute
[Audio]::Mute = $false
[Audio]::Volume = 1

$excuse = Get-Random -InputObject $excuses
# outputs audio
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$speak.Speak($excuse)

# Change back to previous settings
[Audio]::Mute   = $cur_mute
[Audio]::Volume = $cur_audio
}
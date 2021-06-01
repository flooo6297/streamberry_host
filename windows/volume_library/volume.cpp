// to compile (using mingw-w64)
// g++ this_filename.c  -lole32
// outputs current system volume (out of 0-100) to stdout, ex: output "23"
// mostly gleaned from examples here: http://msdn.microsoft.com/en-us/library/windows/desktop/dd370839(v=vs.85).aspx
// download a compiled version here:
// https://sourceforge.net/projects/mplayer-edl/files/adjust_get_current_system_volume_vista_plus.exe.exe (updated, can set it too now!)
#include <windows.h>
#include <commctrl.h>
#include <mmdeviceapi.h>
#include <endpointvolume.h>
#include <stdio.h>
#include <math.h>       /* log */

#define EXIT_ON_ERROR(hr)  \
              if (FAILED(hr)) { printf("error %d occurred\n", -hr); goto Exit; }


#define SAFE_RELEASE(punk)  \
              if ((punk) != NULL)  \
                { (punk)->Release(); (punk) = NULL; }

extern "C" __declspec( dllexport ) int volume_get() {
    IAudioEndpointVolume *g_pEndptVol = NULL;
    bool WindowsLH;
    HRESULT hr = S_OK;
    IMMDeviceEnumerator *pEnumerator = NULL;
    IMMDevice *pDevice = NULL;
    OSVERSIONINFO VersionInfo;

    ZeroMemory(&VersionInfo, sizeof(OSVERSIONINFO));
    VersionInfo.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
    GetVersionEx(&VersionInfo);
    if (VersionInfo.dwMajorVersion > 5)
      WindowsLH = true; // vista+
    else
      WindowsLH = false;

    if (WindowsLH)
    {
      CoInitialize(NULL);

      // Get enumerator for audio endpoint devices.
      hr = CoCreateInstance(__uuidof(MMDeviceEnumerator),
                            NULL, CLSCTX_INPROC_SERVER,
                            __uuidof(IMMDeviceEnumerator),
                            (void**)&pEnumerator);
      EXIT_ON_ERROR(hr)

      // Get default audio-rendering device.
      hr = pEnumerator->GetDefaultAudioEndpoint(eRender, eConsole, &pDevice);
      EXIT_ON_ERROR(hr)

      hr = pDevice->Activate(__uuidof(IAudioEndpointVolume),
                             CLSCTX_ALL, NULL, (void**)&g_pEndptVol);
      EXIT_ON_ERROR(hr)
      float currentVal;
      hr = g_pEndptVol->GetMasterVolumeLevelScalar(&currentVal);
      EXIT_ON_ERROR(hr)
      return (int) round(100 * currentVal); // 0.839999 to 84 :)
    }
    else {
      printf("wrong v of windows, req. vista+ ! \n");
    }
    fflush(stdout); // just in case

Exit:
    SAFE_RELEASE(pEnumerator)
    SAFE_RELEASE(pDevice)
    SAFE_RELEASE(g_pEndptVol)
    CoUninitialize();
    return 0;
}

extern "C" __declspec( dllexport ) int mute_get() {
    IAudioEndpointVolume *g_pEndptVol = NULL;
    bool WindowsLH;
    HRESULT hr = S_OK;
    IMMDeviceEnumerator *pEnumerator = NULL;
    IMMDevice *pDevice = NULL;
    OSVERSIONINFO VersionInfo;

    ZeroMemory(&VersionInfo, sizeof(OSVERSIONINFO));
    VersionInfo.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
    GetVersionEx(&VersionInfo);
    if (VersionInfo.dwMajorVersion > 5)
      WindowsLH = true; // vista+
    else
      WindowsLH = false;

    if (WindowsLH)
    {
      CoInitialize(NULL);

      // Get enumerator for audio endpoint devices.
      hr = CoCreateInstance(__uuidof(MMDeviceEnumerator),
                            NULL, CLSCTX_INPROC_SERVER,
                            __uuidof(IMMDeviceEnumerator),
                            (void**)&pEnumerator);
      EXIT_ON_ERROR(hr)

      // Get default audio-rendering device.
      hr = pEnumerator->GetDefaultAudioEndpoint(eRender, eConsole, &pDevice);
      EXIT_ON_ERROR(hr)

      hr = pDevice->Activate(__uuidof(IAudioEndpointVolume),
                             CLSCTX_ALL, NULL, (void**)&g_pEndptVol);
      EXIT_ON_ERROR(hr)
      int currentVal;
      hr = g_pEndptVol->GetMute(&currentVal);
      EXIT_ON_ERROR(hr)
      return currentVal; // 0.839999 to 84 :)
    }
    else {
      printf("wrong v of windows, req. vista+ ! \n");
    }
    fflush(stdout); // just in case

Exit:
    SAFE_RELEASE(pEnumerator)
    SAFE_RELEASE(pDevice)
    SAFE_RELEASE(g_pEndptVol)
    CoUninitialize();
    return 0;
}
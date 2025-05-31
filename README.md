# PowerShell Process Info Script

This is a simple PowerShell script that prints information about all running processes.
It displays:
* Process ID
* Name
* CPU usage (in seconds, accumulated since the process started)
* Memory usage (in MB)
* User name

The default output is shown in table format.

## Available Flags
* `-Help` — Show help information
* `-OutputFile` <path> — Write output to a file in addition to console
* `-Json` — Output data in JSON format

*Example JSON output:*
```
[
  {
    "Id": 2112,
    "Name": "svchost",
    "CPU": 18.45,
    "Mem": 20.68,
    "User": "NT AUTHORITY\\SYSTEM"
  },
  {
    "Id": 3928,
    "Name": "vdagent",
    "CPU": 17.97,
    "Mem": 11.23,
    "User": "NT AUTHORITY\\SYSTEM"
  }
]
```

## CI: GitHub Actions

This project uses GitHub Actions which are triggered:
* On each commit to the main branch
* On pull requests targeting the main branch

The CI pipeline runs sanity tests defined in the tests/ directory.
You can also run the tests locally using PowerShell.
![obrazek](https://github.com/user-attachments/assets/28f95c7f-1c91-4b2a-90e7-f96430816032)


## Demo Pull Requests
Two pull requests were created to demonstrate how GitHub Actions works:
✅ [Passed PR](https://github.com/antonvoznia/sys-info/pull/3)
❌ [Failed PR](https://github.com/antonvoznia/sys-info/pull/2)

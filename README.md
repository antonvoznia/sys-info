# PowerShell Process Info Script

This is a simple PowerShell script that prints information about all running processes.
It displays:
* Process ID
* Name
* CPU usage (in seconds, accumulated since the process started)
* Memory usage (in MB)
* User name

The default output is shown in table format.

All functionality is implemented in a single file: `sys-info.ps1`

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

## JSON visualizer
To visualize the JSON output, you can use a [simple tool](https://github.com/antonvoznia/json-process-visualizer).

You can modify the script to visualize ot according to your requirements.

## Visualize with Google sheets

1. Convert JSON to CSV using PowerShell:

   Run the following command in PowerShell:

   `(Get-Content processes.json | ConvertFrom-Json) | Export-Csv processes.csv -NoTypeInformation`

   This will create a 'processes.csv' file containing all process entries.

2. Upload CSV to Google Sheets:

   - Open Google Drive
   - Click "New" → "File upload" → select 'processes.csv'
   - Once uploaded, right-click on it → "Open with" → "Google Sheets"

3. To show processes grouped by user:
- Insert → Pivot Table
- Rows: 'User', Values: Sum of 'Mem'
- Then create a chart from that table

This example show how much memory is consumed by each user in MB.
<img width="1689" alt="image" src="https://github.com/user-attachments/assets/dd484a27-4311-4667-8ccc-2488c57909b1" />


## CI: GitHub Actions

This project uses GitHub Actions which are triggered:
* On each commit to the main branch
* On pull requests targeting the main branch

The CI pipeline runs sanity tests and advanced test. They are defined in the tests/ directory.
You can also run the tests locally using PowerShell.
![obrazek](https://github.com/user-attachments/assets/28f95c7f-1c91-4b2a-90e7-f96430816032)



## Demo Pull Requests
Two pull requests were created to demonstrate how GitHub Actions works:
* ✅ [Passed PR](https://github.com/antonvoznia/sys-info/pull/3)
* ❌ [Failed PR](https://github.com/antonvoznia/sys-info/pull/2)

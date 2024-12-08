
| CVE                            | Bug                  | Software       | Location                                  | Tools                       |
| ------------------------------ | -------------------- | -------------- | ----------------------------------------- | --------------------------- |
| [CVE-2009-3895](CVE-2009-3895) | Heap Buffer overflow | libexif 0.6.18 | `exif_entry_fix function` in exif-entry.c | AFL++<br>GDB                |
| [CVE-2012-2814](CVE-2009-3895) | Integer Underflow    | libexif 0.6.20 | `exif_entry_format_value` in exif-entry.c | AFL++ (ASAN)<br>GDB<br>Tmux |

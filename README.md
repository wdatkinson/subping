# subping
Subnet Ping Utility

This script was written to allow monitoring via ping of devices on a given subnet.  It is intended for focused troubleshooting and not for long-term efforts that would be suited by a more monitoriong-centric application.

If the script is run without any arguments, it will display a usage message.  A single command line argument is expected in the form of the first three octets of the target submit in dotted form (192.168.1, 172.16.1, 10.1.1, etc.).

When given a subnet with which to work, the following actions are taken in this order:

1). The current directory is examined for left overs from a previous run and if found they are deleted.
2). The script will take the subnet provided on the command line and initiate a single ping to IP's .2-.254 (last octet).  IP's that return the ping will be stored in a file (ip_list.txt) and the script will report back via STDOUT that number for visual reference.
3). Next a constant ping session is spawned for each found IP and the results are stored in individual files with names based upon the IP being pinged and given a .txt suffix.  Keep in mind that we're talking about concurrent ping processes, all based upon 64 bytes.  So if 27 IP's were discovered in step 2, then 27 ping processes will be launched.  Again, a status message is send to STDOUT for visual reference of the operation.
4). A message is sent to STDOUT with instructions to press ENTER to stop the ping processes and clean up the files.  So the pings in step 3 continue until you press enter.  Pressing enter issues a kill for the running ping processes and then a clean up process is run to strip out the non-ping responses from each file.  When the clean process is complete each IP file will contain only the ping responsed and the number of responses will be determined by how long the script was allowed to run.

After the script is finished, you'll be left with the IP files and the ip_list.txt in the current directory for use in reporting, troubleshooting, etc.  As noted in step 1, upon subsequent runs of the script these files are wiped, so if you want to keep the files from each run, you must manually move them to another location BEFORE running the script again.  Currently there is no warning or prompt prior to the clean-up process.  Perhaps that can be added in the future.

I wrote the script to assist with some troubleshooting at my place of employment.  It is posted here for reference by others as they, like me, look to improve their bash scripting skills.  Feedback is welcome as well as suggestions for future improvements.

# subping
Subnet Ping Utility

This script was written to allow monitoring via ping of devices on a given subnet.  It is intended for focused troubleshooting and not for long-term efforts that would be suited by a more monitoriong-centric application.

If the script is run without any arguments, it will display a usage message.  A single command line argument is expected in the form of the first three octets of the target submit in dotted form (192.168.1, 172.16.1, 10.1.1, etc.).

When given a subnet with which to work, the following actions are taken in this order:

1). Starting with v1.7, the base output directory is now ~/subping and an individual run directory is created under the base output directory for each run.  The name of the run directory is based upon the date and time the script is run.  For example: ~/subping/01222020_0738, which indicates a run on January 22nd, 2020 at 07:38.  In the interest of examining runs over time or extended troubleshooting efforts, the script no longer cleans up pprevious runs.  Those are the responsibility of the user.

2). The script will take the subnet provided on the command line and initiate a single ping to IP's .2-.254 (last octet).  IP's that return the ping will be stored in a file (ip_list.txt) and the script will report back via STDOUT that number for visual reference.

3). Next a constant ping session is spawned for each found IP and the results are stored in individual files with names based upon the IP being pinged and given a .txt suffix.  Keep in mind that we're talking about concurrent ping processes, all based upon 64 bytes.  So if 27 IP's were discovered in step 2, then 27 ping processes will be launched.  Again, a status message is send to STDOUT for visual reference of the operation.

4). A message is sent to STDOUT with instructions to press ENTER to stop the ping processes and clean up the files.  So the pings in step 3 continue until you press enter.  Pressing enter issues a kill for the running ping processes and then a clean up process is run to strip out the non-ping responses from each file.  When the clean process is complete each IP file will contain only the ping responses and the number of responses will be determined by how long the script was allowed to run.

5). A second file will be created with "-times" appended onto the base file name.  This file will contain only the timestamp (hours, minutes and seconds) along with the ping reponse time.  This file is included for graphing purposes.

6). If installed, GNUplot will run against all "-times" files and create a .png in the current directory.  If GNUplot is not installed, then a simple message is displayed that graphing cannot be run.

After the script is finished, you'll be left with the following files in the execution directory:

ip_list.txt - A list of IP's discovered during the run.
IP_ADDR.txt - (where IP_ADDR is the discovered IP address.  192.168.1.1.txt for example.) This file will contain a full time stamp and all of the parsed ping data for each packet sent.  There will be one of these files for each IP discovered during the run.
IP_ADDR-times.txt - This file will contain only the timestamp in hours, minutes and seconds along with the ping time for each ping sent.  Again, one of these files will be created for each IP discovered.  This file can be used to graph in other systems, such as Excel, Google Sheets, or your favorite graphing tool.
IP_ADDR.png - The gnuplot output file.  This will be the graph of the data from the IP_ADDR-times.txt file.

As noted in step 1, upon subsequent runs of the script all output files are wiped, so if you want to keep the files from each run, you must manually move them to another location BEFORE running the script again.  Currently there is no warning or prompt prior to the clean-up process.  Perhaps that can be added in the future.

As I used the subping utility to troubleshoot, it became readily apparent that the need existing to be able to ping a single IP.  So I took the subping code and trimmed it down to work with a single IP.  Running the script from the command line will give you a message with the syntax required.

Lastly, the need arose to be able to schedule the singleping script for a given launch time outside of business hours.  That, or I needed to be online to kick off the process.  I didn't want to jack around with cron for one-off runs, so I wrote the launcher script, which will take the IP, date and time and utilizing EPOCH time, launch the singleping script with the IP passed at the desired date/time.  Once again, syntax can be obtained by running the script from the command line.

I wrote these scripts to assist with some troubleshooting at my place of employment.  It is posted here for reference by others as they, like me, look to improve their bash scripting skills.  Feedback is welcome as well as suggestions for future improvements.

# Programming assignment 6 (pa06) -- Firewalls

### Option 1
(Basic assignment):

Your task is to write a bash script which configures a firewall using IPtables.
In particular, it should be executed on the Kali VM to produce a lasting permanent change to the OS's firewall configuration (across reboots).
You should assume that the computer needs to be configured as a secure web server supporting http and https traffic, with remote ssh access for you.
Further, you want ssh access limited to a particular static IP address (any will do).
Connection tracking should be stateful in both directions, so that you are not leaving wide ranges of ports unnecessarily open, either outgoing in incoming.
Additionally, you should have secure defaults to reject all incoming and outgoing TCP and UDP traffic not necessary for the web server's above-stated functionality.
The examples given in class contain valid firewall configuration options, but do not specify how to save or manage the configuration in a Debian-based operating system (Kali);
you will need to do some internet research to determine the correct way to save the configuration.
You should test your firewall configuration script on the Kali VM, and validate that it behaves as you expect, by using Wireshark to test outgoing traffic and if you can, incoming connections, perhaps via nmap or other methods.
Submit one bash script, with at least on full gramatically complete sentence comments above each configuration command describing what you are doing with EVERY line of of the configuration script.
You should assume that it will be run by a non-root user who has sudo priveledges.


The file should be named: 
fw_setup.sh

We will run something like this to check it:

```bash
bash fw_setup.sh  # to keep thes shell consistent
sudo iptables -S
sudo iptables -L
systemctl reboot
sudo iptables -S
sudo iptables -L
```


### Option 2
(Get a grade for pa06, and replace your lowest assignment):

Perform an in-depth code review and audit of the OpenSnitch firewall, which is a python frontend (go backend) that partly employs IPtables to manage traffic on a per-process basis, with a rule for each PID.
This will be evaluated critically, graded individually, and must be include a thorough technical documentation of the code-base, and demonstrate an understanding of the mechanisms of action of the projects whole code-base.
You should submit a written report and technical diagrams.

You should try to tackle at least one of the outstanding GitHub issues (preferred), and if you can't find any reasonable issues to tackle, propose other code-related changes proposed to fix or improve the project (can be simple UI improvements if you can't find any security related issues).
If you feel this issue was solidly solved enough, then it may be helpful to create a merge request for the main project.

Your report should provide an easy-to-read documentation for the main operation of each project file and component.

OpenSnitch information:
* https://www.opensnitch.io/
* https://github.com/evilsocket/opensnitch/
* https://securityonline.info/opensnitch/

The following may help you in writing your code review and audit of opensnitch

Example audit reports for software security:
* https://www.x41-dsec.de/reports/Kudelski-X41-Wire-Report-phase1-20170208.pdf
* https://eprint.iacr.org/2016/1013.pdf
* https://www.nitrokey.com/sites/default/files/NitrokeyFirmwareSecurityAuditReport05-2015.pdf
* https://www.nitrokey.com/sites/default/files/NitrokeyHardwareSecurityAuditReport08-2015.pdf

Example audit reports for pentesting:
* http://www.niiconsulting.com/services/security-assessment/NII_Sample_PT_Report.pdf
* https://github.com/juliocesarfort/public-pentesting-reports
* https://www.sans.org/reading-room/whitepapers/testing/writing-penetration-testing-report-33343
* https://www.offensive-security.com/reports/sample-penetration-testing-report.pdf
* https://darrylmacleod.wordpress.com/2012/03/26/penetration-testing-report-templates/
* http://190.90.112.209/penetration-testing-sample-report.pdf


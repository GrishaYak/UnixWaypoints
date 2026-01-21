# Waypoints for Linux terminal

#### This is a program that is used for fast navigation throught folders in terminal.

---

### Installation
1) Download the code from this repo
2) Execute installWaypoints.sh <br> *add flag **--stay** to keep source code here*
3) Restart your terminal.
4) Done, now you can use it.

---

### How to use it?
*  **wp** <br>
  This function is used to manage waypoints. Due to it, you can: <br> 
  a) Get the list of created waypoints <br>
  b) Delete created waypoint (rm) <br>
  c) Add a new waypoint in directory where you are located at (add)
* **tp** <br>
  This function is used to *teleport* to a waypoint. As an argument, give it a name of the waypoint you want to get to.

---

### Example of usage

```
user@dist:~$ wp ls
ex2
important
ex1
user@dist:~$ wp rm ex? -E
user@dist:~$ wp ls
important
user@dist:~$ cd Downloads/
user@dist:~/Downloads$ wp add d
user@dist:~/Downloads$ cd ..
user@dist:~$ tp d
user@dist:~/Downloads$ 
```
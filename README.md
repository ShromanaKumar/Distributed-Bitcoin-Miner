README File:
•	Project Team –
o	Shromana Kumar
o	Sangpil Youm

•	Steps to execute program – 
o	First, we have to compile the program in Erlang.

Command:
c(assignment1).

o	Then we have to execute the “assignment1:master(<No_Of_Input_Zeroes>)” function with an input of the no of zeroes needed in the bitcoin.

Command:
assignment1:master(1).

 

•	Steps to setup Server Worker Connection –
o	Start erlang shell with below command having your IP address for both Server and Worker node. Note that both server and worker have to have the same cookie and the IP address has to be correct for the connection to be setup successfully. The name of the terminal should be in the format of “name@ip_address” and name can be anything.

Command:
erl -name shromana@10.20.0.203 -setcookie guitar
erl -name shro@10.20.0.203 -setcookie guitar

 
 

o	For the worker node to request work from the Server, it needs to call the below function “assignment1:start_worker(<Terminal_Name>)” and pass its terminal name. If successful connection is established then erlang shell will return true else it will return false or ignored.

Command:
assignment1:start_worker('shro@10.20.0.203').
 

•	Size of Work Unit –
o	Our problem here is to mine bitcoins with the input number of zeroes. So, we have decided to create a work unit of 4 actors (2 actors per working nodes) for our problem which would provide ample scope for parallelism, without slowing our machines down which aren’t built for industrial purposes.

•	Result of running the program with input size 4 –
Please find below the result of running the program with an input size 4
 

•	Running Time and CPU Time –
o	We are printing the running time and the CPU time on the terminal. We are performing this activity using Erlang library functions. As you can see that the ratio of CPU time to Running Time is more than 1, which proves that we have multiple actors working behind the scenes and hence we have parallelism in our program.

 

•	Coins with most 0s – 
We found a bitcoin with a maximum input of 8 leading 0s
 

•	Largest number of working machines you were able to run your code with –
o	We were able to connect 2 working machines together and mine coins using both the machines. We can show the connection using the command “nodes().”
 

 

o	When we use the command “i().” On the erlang shell, we can see the list of process running. In the below screenshot, you can only see the actor/miner process running on the worker node. This list of processes would not have the master function call as that would be running on the Server node. 

 

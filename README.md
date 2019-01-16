# stroop_task
A repository containing two MATLAB files, my_stroop.m and stroop_processing.m. The my_stroop.m file runs a classic cognitive science experiment, the Stroop Task, using Psychtoolbox and producing a .csv file with the subject's results. The stroop_processing.m file contains a script for preliminary processing of the data obtained in the task.

In the classic version of the Stroop Task, a color word is presented on a screen. The ink color of the text is either congruent or incongruent with the color word (i.e. congruent: GREEN in green ink, incongruent: GREEN in red ink). The participant must name the color of the text presented on the screen. Subjects on average have a longer response time and higher error rate in the incongruent condition due to inteference. This paradigm has been adapted to test various cognitive phenomena.

In order to use the code in this repository, first, run my_stroop.m. Follow the instructions presented on the screen. Next, run stroop_processing.m on the resulting .csv file.

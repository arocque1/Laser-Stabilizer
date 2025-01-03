# Laser-Stabilizer

Constructing the circuit given in the two pictures attached, the laser will point 
in the forward direction it is facing at the moment the code is run. There is a 
margin of error with the laser's accuracy in pointing at the original target, more 
noticable whenrotating the laser on a flat surface(z-axis). This is because of the 
distance between the accelerometer and the laser pointer on the breadboard. This could be 
mitigated using some basic geometry and trigonometry to compensate for the distance difference, 
which I might implement when converting this code into C++/arduino code.

Here is a video I made demonstrating the functionality:

youtu.be/HD2o1BTDFdk?si=jBbx1nSXKkDvluIN

Its hard to see the laser in the first half of the video because of the video quality, 
but it is pointing at the red piece of tape that I stuck to my wall. The laser is more
visible in the second part of video, where I am using the MPU 6050 while detatched from the
laser to use it a remote to point the laser.



Parts used:

- Breadboard
- Arduino UNO
- 3 SG90 Servo Motors
- MPU 6050
- Any small laser pointer
- A lot of double and single sided tape!

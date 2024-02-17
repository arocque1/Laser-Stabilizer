# Laser-Stabilizer

Constructing the circuit given in the two pictures attached, the laser will point 
in the forward direction it is facing at the moment the code is run. There is a 
margin of error with the laser's accuracy in pointing at the original target, more 
noticable whenrotating the laser on a flat surface(z-axis). This is because of the 
distance between the accelerometer and the laser pointer on the breadboard. This could be 
mitigated using some basic geometry and trigonometry to compensate for the distance difference, 
which I might implement when converting this code into C++/arduino code.

Parts used:

- Breadboard
- Arduino UNO
- 3 SG90 Servo Motors
- MPU 6050
- Any small laser pointer
- A lot of double and single sided tape!

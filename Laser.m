%% Setup
clear
clc
a = arduino('COM3', 'Uno', 'Libraries',{'servo', 'I2C'});

sdir = servo(a, 'D2'); % Blue
sroll = servo(a, 'D4'); % White
spitch = servo(a,'D6'); % Yellow

%SDA -> A4
%SCL -> A5

imu = mpu6050(a);

fprintf("Setup Complete" + '\n')


%% Stabilizer

% Based on the acceleration due to gravity on the x y and z axis
% of the accelerometer, the code adjusts the laser using servos so
% that it will point at its initial target (straight forward)

% Didn't include the adjustment of rotational motion along the x-y plane
% because it made the program slow down, since MATLAB isn't that fast for an 
% application like this

clc
i = 1;
clear pos
clear pavg
clear dsum
fprintf("Calibrating..." + '\n')
writePosition(spitch,0.5)
writePosition(sroll,0.5)
writePosition(sdir,0.5)

pin_btn = 'D5';
pin_x = 'A0';
pin_y = 'A2';
a.configurePin(pin_btn,'pullup')

for i = 1:50
    pos = readAcceleration(imu);
    dir = readAngularVelocity(imu);
    pavg(i,1:3) = pos;
    davg(i,1) = dir(1,3);
end
pos = readAcceleration(imu);
accx = pavg(1,2);
accy = pavg(1,1);
accz = pavg(1,3);
croll = rollt(accx,accy,accz);
cpitch = pitcht(accx,accy,accz);
pavg = mean(pavg);
davg = mean(davg);
davg = rad2deg(davg)
spos = 90;
asum = [0 0];

fprintf('Stabilizing\n')
k = 2;
dsum(1,1) = 0.5;
t = .05
while 1
    pos = readAcceleration(imu);
    accx = pos(1,2) - pavg(1,2);
    accy = pos(1,1) - pavg(1,1);
    accz = pos(1,3);
    roll = rollt(accx,accy,accz);
    pitch = pitcht(accx,accy,accz);
    ang = readAngularVelocity(imu);
    ang = ang(1,3);
    ang = rad2deg(ang);
    ang = ang - davg

    pitch = pitch + 90;
    pitch = pitch/180;
    

    roll = roll + 90;
    roll = roll/180;
    tic
    asum = [asum(1,2) ang]; % Sum of Dv in 1,1 and newest Dv in 1,2
    asum1 = asum(1,2)*t % change in position
    spos = asum1 + spos % Adds change in position to old position
    dir = 180 - spos
    dir = dir/180;

    writePosition(spitch,abs(pitch));
    writePosition(sroll,abs(roll));
    writePosition(sdir,dir)
    
    
    t = toc;

end


%% Left and Right Stabilizer

% Integrates the angular velocity of gyroscope when the user
% is rotating the laser (along the z-axis) on a flat and level surface
clc

ang(1:2) = 0;
for i = 1:20
    dir = readAngularVelocity(imu);
    davg(i,1) = dir(1,3);
end
davg = mean(davg);
davg = rad2deg(davg)
spos = 90;
asum = [0 0]; % Sum of angular velocities
disp('complete')
pause(1)
i = 1;
disp("loop " + i)
it = 1;
t = .05
while 1
    tic
    ang = readAngularVelocity(imu);
    ang = ang(1,3);
    ang = rad2deg(ang);
    ang = ang - davg

    asum = [asum(1,2) ang]; % Sum of Dv in 1,1 and newest Dv in 1,2
        asum1 = asum(1,2)*t % change in position
        spos = asum1 + spos % Adds change in position to old position
        dir = 180 - spos
        dir = dir/180;
    

    writePosition(sdir,dir)
    
    %fprintf('\n\n\n\n\n\n\n\n\n\n\n\n')
    %disp("loop " + i)
    t = toc
end



%% Pointer

% Configurated for when the laser and servos are stationary
% and the accelerometer is detatched to use as a "remote".
% Based on the accelerometer data from the "remote", the laser will
% point where the "remote" is pointing, relatively.


clc
i = 1;
clear pos
clear pavg
clear dsum
fprintf("Calibrating..." + '\n')
writePosition(spitch,0.5)
ang(1:2) = 0;
for i = 1:20
    dir = readAngularVelocity(imu);
    davg(i,1) = dir(1,3);
    pos = readAcceleration(imu);
    pavg(i,1:3) = pos;
    davg(i,1) = dir(1,3);
end
davg = mean(davg);
davg = rad2deg(davg)
pos = readAcceleration(imu);
accx = pavg(1,2);
accy = pavg(1,1);
accz = pavg(1,3);
croll = rollt(accx,accy,accz);
cpitch = pitcht(accx,accy,accz);
pavg = mean(pavg);
spos = 90;
asum = [0 0]; % Sum of angular velocities
disp('complete')
pause(1)
i = 1;
disp("loop " + i)
it = 1;
t = .05
while 1
    tic
    ang = readAngularVelocity(imu);
    ang = ang(1,3);
    ang = rad2deg(ang);
    ang = ang - davg

    pos = readAcceleration(imu);
    accx = pos(1,2) - pavg(1,2);
    accy = pos(1,1) - pavg(1,1);
    accz = pos(1,3);
    pitch = pitcht(accx,accy,accz);
    pitch = pitch + 90;
    pitch = pitch/180;

    asum = [asum(1,2) ang]; % Sum of Dv in 1,1 and newest Dv in 1,2
        asum1 = asum(1,2)*t % change in position
        spos = asum1 + spos % Adds change in position to old position
        dir = 180 - spos
        dir = dir/180;
        
    

    writePosition(sdir,1 - dir)
    writePosition(spitch,1 - pitch);
    
    %fprintf('\n\n\n\n\n\n\n\n\n\n\n\n')
    %disp("loop " + i)
    t = toc
end
%% Extra Testing

for i = 1:50
        o = readAcceleration(imu);
        xr = o(1,1);
        yr = o(1,2);
        zr = o(1,3);
        avg(i,1) = xr;
        avg(i,2) = yr;
        avg(i,3) = zr;
end
avg = mean(avg)

while 1
    

    
    o = readAcceleration(imu);

   

    ax = 0;
    ay = 0;
    az = 0;

    sx = 0;
    sy = 0;
    sz = 0;

    xr = o(1,1) - avg(1,1);
    yr = o(1,2) - avg(1,2)
    zr = o(1,3) - avg(1,3);

    if abs(xr) > + 0.05 || abs(xr) < - 0.05
        ax = ax + xr;
        sx = sx + ax;
    end
    if abs(yr) > + 0.05 || abs(yr) < - 0.05
        ay = ay + yr;
        sy = sy + ay
    end
    if abs(zr) > 0.08
        az = az + zr;
        sz = sz + az;
    end
    
    


    
    
    
end

%% Functions
function roll = rollt(accx,accy,accz)
    hyp = sqrt((accx^2)+(accz^2));
    roll = atand(accy/hyp);
end
function pitch = pitcht(accx,accy,accz)
    hyp = sqrt((accy^2)+(accz^2));
    pitch = atand(accx/hyp);
end


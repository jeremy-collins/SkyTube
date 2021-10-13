initialHeight = 100; %m
fluidDensity = zeros(resolution,1); %initial fluidDensity = 0
initialVelocity = -53; %terminal velocity in m/s
x = linspace(0,initialHeight,resolution)';
desiredAcc = 2*(exp(-(x/5))).*gravity + .49*gravity; %G's x*0+1.421*gravity; 

resolution = 1000;
maxTime = 30;
gravity = 9.806; %m/s2
dt = maxTime/resolution;
impactTime = 30;


% for i = 2:resolution
%     fluidDensity(i) = 500;
% end

%fluidDensity = exp((x)/7)+200; %linspace(1.225,997,resolution)'; %kg/m3

t = linspace(0,maxTime,resolution)';
humanDensity = 985; %kg/m3
humanMass = 100; %kg
humanFrontalArea = 0.18; %m2
humanVolume = 0.062; %m3
height = zeros(resolution,1);
velocity= zeros(resolution,1);
acceleration = zeros(resolution,1);
% time = zeros(resolution,1);
C_D = 1;

gravityForce = gravity*humanMass; %N
pressureDrag = 0; %N
buoyancyForce = 0; %N

velocity(1) = initialVelocity;
height(1) = initialHeight;

for i = 2:resolution
    fluidDensity(i) = (gravityForce + humanMass*desiredAcc(i))/(humanVolume*gravity + 0.5*velocity(i-1)^2*humanFrontalArea*C_D);
    pressureDrag = 0.5*fluidDensity(i)*velocity(i-1)^2*humanFrontalArea*C_D; %N upward
    buoyancyForce = fluidDensity(i)*humanVolume*gravity; %N upward
    dv = (pressureDrag + buoyancyForce - gravityForce)/humanMass*dt;
    velocity(i) = velocity(i-1) + dv;
    acceleration(i) = dv/dt/gravity;
    height(i) = height(i-1) + velocity(i)*dt;
    if height(i) <= 0 && height(i-1) > 0
        impactTime = i*dt;
        disp("Impact Time(s):");
        disp(i*dt);
        disp("Impact Velocity (m/s): ")
        disp(velocity(i));
    end
end

figure(1)
plot(t,height)
xlabel('Time [s]');
ylabel('Height [m]');
title('Height')
ylim([0, initialHeight]);
xlim([0,impactTime]);

figure(2)
plot(t,velocity)
xlabel('Time [s]');
ylabel('Velocity [m/s]');
title('Velocity')
xlim([0,impactTime]);

figure(3)
plot(t,acceleration)
xlabel('Time [s]');
ylabel('Acceleration [Gs]');
title('Acceleration')
xlim([0,impactTime]);

figure(4)
plot(t,fluidDensity)
xlabel('Time');
ylabel('Fluid Density [kg/m^3]');
title('Fluid Density')
xlim([0,impactTime]);
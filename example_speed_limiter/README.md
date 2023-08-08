**Vehicle speed limiter**

Adds the ability to limit the top speed of the car via a key bind.

Unfortunately the kp,kd,ki values of the PID don't seem to work for every vehicle so may need specific tuning. I'm not sure how the game makes it work for all vehicles. 

This example adds a generic limiter to all vehicles, the key bind can be found in the "vehicle" section in the key bind options. Really though, it's intended to be added to a specific vehicle and tuned to suit.

The PID code comes mostly directly from BeamNG.drive in their own speed limiter code.
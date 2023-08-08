**Example mod for the generic data graph UI app (simple)**

This is an example mod to stream vehicle data to the generic graph (simple) ui app in BeamNG.drive

The graph variables are: ``{ key, value, scale, unit, renderNegatives, color }``

* ``key`` shows up as the text/name
* ``value`` is the value to display, e.g: ``electrics.values.throttle``
* ``scale`` is the scale the value ranges from
* ``unit`` is a textual representation of the unit of the value. Can be empty.
* ``renderNegatives`` whether or not the value can be negative (steering input is one example)
* ``color`` the colour of the line to draw in ``{R, G, B, A }`` notation with values from 0-255
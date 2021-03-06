AtomicLoop
^^^^^^^^^^

`show example <#getting-started>`_ | `jump to docs <#documentation>`_

Create atomic loop iterations (let the current iteration finish even when interrupted).

A simple context manager that asynchronously listens to potential
``SIGINT`` and ``SIGTERM`` and provides you with **plain boolean flag** that can be
used to control the iteration flow of a ``while`` loop based on whether or not
an interrupt/terminate signal was received.

This was formerly built for reinforcement learning library that trains its agents
in iterations and has to gracefully finish the current running episode every time
the training is interrupted.

It will be most useful in similar use cases, but can be actually used for anything
else. Technically, any block of code that needs to run without an interruption.

Note that you will still be able to kill the running process using ``SIGKILL``.

Getting Started
###############

.. code-block:: shell

	pip3 install atomicloop


The following example loop runs 3 iterations, each lasting three seconds.
You can try interrupting one of the steps by pressing ``Ctrl+C`` (which sends
``SIGINT`` to the process). You will see the signal feedback but the program
will wait for the current iteration to finish and exits **after** the loop
iteration is done.

Moreover, you can see the context manager is aware whether or not it finished
due to an interruption.

.. code-block:: python

	import time
	from atomicloop import AtomicLoop


	# Optional callback handlers ----------------------------------------
	def on_signal(signal, frame):
	print(f'  Received signal: {signal}')
	print('  Finishing current step before terminating')


	def on_exit(was_interrupted):
	print('  Ended training')
	print(f'  Interrupted? {was_interrupted}')


	# Running the loop --------------------------------------------------
	goal_steps = 3

	with AtomicLoop(on_signal, on_exit) as loop:
		step_no = 0
		while loop.run and step_no < goal_steps:
			print(f'Starting training step #{step_no}')
			time.sleep(3) # simulating some code execution
			print(f'Finished training step #{step_no}')
			print('----------------------------------\n')
			step_no += 1


Documentation
#############

``atomicloop.AtomicLoop(on_signal=None, on_end=None)``
======================================================

The main and only class that creates the desired context manager.

*on_signal* is a callable that gets invoked on incoming
``SIGINT`` or ``SIGTERM``. It is called with 2 arguments:
the signal number and the current stack frame. For details
on the arguments, please consult *handler* part in
`official signal.signal documentation
<https://docs.python.org/3/library/signal.html#signal.signal>`_.


*on_end* is a callable that gets invoked *after* exiting
the context (after ``with`` block). It is called with
a single boolean argument stating whether or not the
execution was interrupted.

``AtomicLoop()`` returns a new instance. To access the boolean
flag for flow control, you have to read the flag as the instance's
attribute.

The ``.run`` boolean flag states whether or not the program should
continue its execution. It is ``True`` by default and switches to
``False`` when an interruption signal was received.

You can also use one of many synonymous attributes:

* ``loop.run``

* ``loop.loop``

* ``loop.move``

* ``loop.cont``

* ``loop.keep``

* ``loop.keep_going``

* ``loop.uninterrupted``

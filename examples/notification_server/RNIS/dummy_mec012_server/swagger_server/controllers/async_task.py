import sys
import time
import atexit
from flask import current_app
from threading import Thread
import logging
import random
import logging

logging.basicConfig(format='%(levelname)s:%(message)s', level=logging.DEBUG)

## Each second an output_msg is shown and eventually the method with name callback_name belonging to this_object is called.
def simulate_processing(min_time_sec, max_time_sec, output_msg, this_object, callback_name, pars):
    iterations = random.randint(min_time_sec, max_time_sec)
    logging.info("The process will take around " + str(iterations) + " seconds")
    for i in range(0, iterations):
        time.sleep(1)

    logging.info(output_msg + " completed!")
    class_method = getattr(this_object.__class__, callback_name)
    class_method(this_object, pars)


def start_sim_process(min_time_sec, max_time_sec, output_msg, this_object, callback_name, pars):
    if min_time_sec > max_time_sec:
        logging.warn(
            "Min time cannot be greater than max time. Setting min to 10 seconds and max to 20 seconds, respectively.")
        min_time_sec = 10
        max_time_sec = 20
    logging.info("Starting the process simulator...")
    thr = Thread(target=simulate_processing,
                 args=[min_time_sec, max_time_sec, output_msg, this_object, callback_name, pars])
    thr.start()


##What does this function do ? It triggers the callback after a given timeout
def trigger_callback_after_timeout(timeout, this_object, callback_name, pars):
    logging.info("Waiting " + str(timeout) + " seconds before triggering the process")
    time.sleep(timeout)
    class_method = getattr(this_object.__class__, callback_name)
    class_method(this_object, pars)


def start_workflow(waiting_time, this_object, callback_name, pars):
    thr = Thread(target=trigger_callback_after_timeout, args=[waiting_time, this_object, callback_name, pars])
    thr.start()

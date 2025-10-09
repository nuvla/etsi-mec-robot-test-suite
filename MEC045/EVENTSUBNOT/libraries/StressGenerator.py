import multiprocessing
import time

class StressGenerator:
    ROBOT_LIBRARY_VERSION = '0.0.1'
    
    def generate_cpu_load(self, duration=30, cpu_cores=None):
        """
        Generate CPU load by spinning up processes that perform intensive calculations.
        
        Args:
            duration: How long to run the stress test in seconds
            cpu_cores: Number of CPU cores to use. If None, uses all available cores.
        """
        if cpu_cores is None:
            cpu_cores = multiprocessing.cpu_count()
            
        processes = []
        
        def cpu_intensive_task():
            end_time = time.time() + duration
            while time.time() < end_time:
                # Perform CPU-intensive calculations
                for i in range(10000000):
                    _ = i * i
        
        # Create and start processes
        for _ in range(cpu_cores):
            p = multiprocessing.Process(target=cpu_intensive_task)
            p.start()
            processes.append(p)
            
        # Wait for all processes to complete
        for p in processes:
            p.join()
            
        return f"Generated CPU load on {cpu_cores} cores for {duration} seconds"
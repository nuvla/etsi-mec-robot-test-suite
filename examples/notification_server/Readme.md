## How to Run a Robot Script to Validate a Web Server's Notifications


1. **Prerequisites**
   - Ensure that Docker is installed on your computer. You can check this by running the command `docker --version` in your command prompt or terminal. If Docker is not installed, download and install it from the official Docker website.
   - Ensure that docker-compose is installed on your computer. You can check this by running the command `docker-compose --version` in your command prompt or terminal. If Docker is not installed, download and install it from the official Docker website.


2. **Start the SUT (Web Server which sends notifications)** with `docker-compose up RNIS`
3. **Run the Robot Test** with `docker-compose up robot`
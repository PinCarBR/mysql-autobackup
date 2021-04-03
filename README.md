<!-- TODO: Revisar README.md -->
# mysql-autobackup

## Setup Instructions

### Install Docker

1. First, in order to ensure the downloads are valid, add the GPG key for the official Docker repository to your system:  
`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`
2. Add the Docker repository to APT sources:  
`sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"`
3. Next, update the package database with the Docker packages from the newly added repo:  
`sudo apt-get update`
4. Make sure you are about to install from the Docker repo instead of the default Ubuntu 16.04 repo:  
`apt-cache policy docker-ce`  
 You should see output similar to the follow:  

    ```yml
    docker-ce:
        Candidate: 18.06.1~ce~3-0~ubuntu
        Version table:
            18.06.1~ce~3-0~ubuntu 500
                500 https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
    ```

5. Finally, install Docker:  
`sudo apt-get install -y docker-ce`
6. Docker should now be installed, the daemon started, and the process enabled to start on boot. Check that it's running:  
`sudo systemctl status docker`
7. If you want to avoid typing sudo whenever you run the docker command, add your username to the docker group:  
`sudo usermod -aG docker ${USER}`
8. To apply the new group membership, log out of the server and back in.
9. Afterwards, you can confirm that your user is now added to the docker group by typing:  
`id -nG`  

- For more info, visit: <https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04>

### Install Docker Compose

1. We'll check the current release and if necessary, update it in the command below:  
`ssudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`
2. Next we'll set the permissions:  
`sudo chmod +x /usr/local/bin/docker-compose`
3. Then we'll verify that the installation was successful by checking the version:  
`docker-compose -v`

- For more info, visit: <https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-16-04>

### Install the repository into the VPS

1. Clone the repository.
2. Step into the just created folder

### Configure environment variables

1. If you want to change the backup frequency, just change the `FREQUENCY` parameter inside .env file
2. The following options are available: `15min`, `hourly`, `daily`, `weekly` and `monthly`
3. If you have any issues to execute the backup due to `Authentication plugin 'caching_sha2_password' cannot be loaded` error, please run the following command on the MySQL database: `ALTER USER 'root' IDENTIFIED WITH mysql_native_password BY 'your_root_password';`
4. The maximum historic size of backup files is given by the env variable `HIST_SIZE`, adjust it to your needs

### Execute all the services

`docker-compose up -d` or `docker-compose up -d --build --force-recreate` to force recreation of image and container  
Check if everything is working via the commands:  
`docker-compose ps` or `docker ps`  
Check the logs of each container via the command:  
`docker-compose logs container_name`

### To restore the backup

1. Retrieve the latest backup
2. Create a new directory to receive the extracted backup files: `mkdir /.../$MYSQL_BACKUP_PREFIX`
3. Run `tar -xzf /.../$MYSQL_BACKUP_PREFIX.tar.gz -C /.../$MYSQL_BACKUP_PREFIX`
4. Execute the command `mysqlsh -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD -- util load-dump /.../$MYSQL_BACKUP_PREFIX`
5. To restore the incremental changes: <https://dev.mysql.com/doc/refman/8.0/en/point-in-time-recovery-binlog.html>

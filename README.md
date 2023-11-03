# Fullstack-Web-Application-Over-AWS-Cloud
AWS Cloud Deployments using best practices from Devops 

Deploying Fullstack Web Application Over AWS Cloud

Requirements:
•	Need to have a valid AWS account
Technology used:
•	RDS Mysql
•	Wordpress
•	Terraform 
•	Apache Tomcat
•	PHP
•	AWS ALB

1.	Clone the Repository on your local Server:
git clone https://github.com/amithtg-199/Fullstack-Web-Application-Over-AWS-Cloud.git

2.	Use Terraform to create standard 3 Tier network with standard Security practices.

a.	Install Terraform on local server as per the provided link.
 

b.	From the Cloned project navigate into terraform_State_files folder where you can see below files.
 
Before Starting with deployment need to setup the environment and generate ssh-keygen for ssh.
c.	On the local server install install aws cli, run below commands:
sudo apt-get update
sudo apt  install awscli

d.	Then Input the AWS IAM user AccesssKey ID and Secret Access Key, run below command enter the required data prompted.
aws configure
AWS Access Key ID [None]: <AWS_IAM_USER_ACCESS_KEY_ID>
AWS Secret Access Key ID [None]: <AWS_IAM_USER_SEC_ACCESS_KEY>

e.	Now Create ssh-keygen for ssh authentication for EC2 machines (Remember set the name of the file as given below only)
ssh-keygen -t rsa -b 4096
Enter file in which to save the key (/home/ubuntu/.ssh/id_rsa): ec2_rsa
       Note: do not pass any passphrase
       Copy the Private Key ec2_rsa to ~/.ssh/ path and keep the ec2_rsa.pub under the terraform_state_files along with the other state files.

f.	Now initialize the Terraform and import the providers required
terraform init
terraform plan


If no error in above 2 commands now run below to create the Infra:

terraform apply
Once completed it show something like this:
 

Now the Infra is setup next we need to setup Application.

3.	Loging into Jump Server and then accessing application server
On local terminal run as below:
ssh -i ~/.ssh/ec2_rsa ubuntu@<Jump_server_Public_IP>

Copy the content of ec2_rsa content and create the same inside the Jump_server and provide 400 permission.
vi ec2_rsa 
##Enter the Required data##
:wq!

chmod 400 ec2_rsa
	ssh -i “ec2_rsa” ubuntu@<Application_server_private_ip>
4.	Configure WordPress Application.

a.	All the required dependencies are already added in the EC2 TF state file, verify them once running below command:
sudo apt install apache2 \
                 ghostscript \
                 libapache2-mod-php \
                 php \
                 php-bcmath \
                 php-curl \
                 php-imagick \
                 php-intl \
                 php-json \
                 php-mbstring \
                 php-mysql \
                 php-xml \
                 php-zip

b.	Install Wordpress:

sudo mkdir -p /srv/www
sudo chown www-data: /srv/www
curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www


c.	Configure Apache for wordpress
sudo touch /etc/apache2/sites-available/wordpress.conf
sudo vi /etc/apache2/sites-available/wordpress.conf

Add below entry:
<VirtualHost *:80>
    DocumentRoot /srv/www/wordpress
    <Directory /srv/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /srv/www/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>

Enable the site:
sudo a2ensite wordpress

Enable the URL rewriting:
sudo a2enmod rewrite

Disable the default “It Works” site with:
sudo a2dissite 000-default

Reload apache2 to apply all changes:
sudo service apache2 reload

d.	Configure the RDS Mysql DB

•	Login to Application Server and access the Mysql DB:
mysql -h <RDS_ENDPOINT> -u <DB_MASTER_USER_NAME> -p
Obtain the 2 variable from AWS RDS UI
 
Can Obtain the Password set from the Secret Manager
 

Once Logged in Create Database and User:
CREATE DATABASE wordpress;

CREATE USER 'app '@ '% '  IDENTIFIED BY '<Your_password> '

GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER 
ON wordpress.* TO 'app '@ '% ' ;

FLUSH PRIVILEGES;

quit;

5.	Configure WordPress to connect to the database
sudo -u www-data cp /srv/www/wordpress/wp-config-sample.php /srv/www/wordpress/wp-config.php

Configure the Connecting values:
sudo -u www-data sed -i 's/database_name_here/wordpress/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/username_here/app/' /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i 's/password_here/<your-password>/' /srv/www/wordpress/wp-config.php

sudo -u www-data nano /srv/www/wordpress/wp-config.php
Replace the below lines with the values provided in https://api.wordpress.org/secret-key/1.1/salt/

define( 'AUTH_KEY',         'put your unique phrase here' );
define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
define( 'NONCE_KEY',        'put your unique phrase here' );
define( 'AUTH_SALT',        'put your unique phrase here' );
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
define( 'NONCE_SALT',       'put your unique phrase here' );

Go to the line and enter ctrl+k will delete a line each time you press the sequence.
Once all are replaced, change the localhost in DB_HOST to RDS Endpoint.
 
At last enter Ctrl+x followed by y and then enter

6.	Access the Wordpress URL from AWS ALB DNS
 
 


# TERRAFORM PROJECT
## The project is the automation of the process of creating public proxy leading to private servers with the use of load balancer as this architecture:
![]()

------
## With the provided terraform files and modules the process is completed only the user needs to provide the variable needed for attributes and those are :

**vpc_cidr_block** : it's the cidr block of the main vpc and it's provided as string.

**lb_attributes** : It's the attributes of the load balancers and it's provided as list of object starting with the public load balancer then the private one and the attributes are name(the name of load blanacer), internal(boolean of either if it's public or not).

**public_subnets_attributes** : It's the attributes of the public subnets and it's provided as a list of objects with the number of object as the number of public subnet and the attributes cidr(cidr block of subnet), id(name of subnet), az(avalibilty zone).

**private_subnets_attributes** : same as public but for private.

-----

## TASK:
### 1- Screenshot from creating and working on workspace dev.

![]()

### 2- Screenshot from the configuration of the proxy.

![]()

### 3- Screenshot from the public dns of the load balancer when you send a traffic to it from a browser and it returns the content of the private ec2s.

![]()

### 4-creenshot from the s3 that contain the state file. 

![]()
# Guide to Setting Up PostgreSQL with Docker

This document describes how to configure, stop, start, and access a PostgreSQL database using Docker. It includes detailed step-by-step instructions and command examples.

### Prerequisites

Before starting, make sure you have Docker installed on your system. If you don't have it installed, follow the instructions on [Docker's official page](https://docs.docker.com/get-docker/).

### Useful Commands

**Start containers**


```
docker start <name_of_container>
```


**Stop containers**


```
docker stop <name_of_container>
```



**Remove containers**



```
docker rm <name_of_container>
```


**List Containers**



```
docker ps -a
```

**Get container IP**


```
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <name_of_container>

```


## Step 1: Download the PostgreSQL Image

To **download** the PostgreSQL image, open your terminal and run the following command:


```
docker pull postgres
```


## Step 2: Create the PostgreSQL Container

To **create** a PostgreSQL container, open your terminal and run the following command:

--name: Enter a custom name for your container
-e: This flag is used to define environment variables that will be passed to the container.
-p: Expose PostgreSQL port 5400 to the outside so it can be used by other applications like PgAdmin.
-d: This flag tells Docker to run the container in the background.


```
docker run --name borges-postgres -e POSTGRES_USER=borges -e POSTGRES_PASSWORD=password -e POSTGRES_DB=borgesdb -p 5400:5432 -d postgres
```


![alt text](image.png)

## Step 3: Run the PostgreSQL Container

To **run** a PostgreSQL container, open your terminal and run the following command:
This command allows us to connect to the PostgreSQL CLI running inside the Docker container.

-i: Provide an interactive session
-t: Allocate a terminal for the session



```
docker exec -it borges-postgres bash
```
![alt text](image-1.png)

## Step 4: Connect to PostgreSQL

Once inside the terminal, we can connect to PostgreSQL by running the following command:
- h: Hostname
- U: Username  



```
psql -h localhost -U borges borgesdb

```
![alt text](image-2.png)

We can also connect using the container's IP and specifying the port:

```
psql -h <container_ip> -p <container_port> -U <username> <database>

```
![alt text](image-3.png)

## Step 5: Verify We Can See Databases in PostgreSQL

Now we will verify that we can execute SQL lines using the \l command to see all databases.

![alt text](image-4.png)

## Step 6: Verify We Can Connect Using Database Managers

Open pgAdmin 4 and try to register a new server using the exposed port 5400:
![alt text](image-5.png)
![alt text](image-6.png)

## Step 7: Import Data into the PostgreSQL Database ##

### Python Script to Import Data

The following Python script facilitates the insertion of columns and data into a PostgreSQL table. It reads data from a CSV file, cleans the column names, converts data types, generates a table schema, creates the table in PostgreSQL, and inserts the data.

### Environment Variables

Make sure to create a .env file in the same directory as your script with the following content:

By following these steps, you can easily set up PostgreSQL using Docker and import data from a CSV file into your PostgreSQL database.
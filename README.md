# Airbnb Data Analysis Project

This project uses Docker to create a PostgreSQL database environment to analyze an Airbnb dataset. The project includes loading data from a CSV file into the database and running SQL queries to answer specific questions.

## Project Structure

- `tableandcolumns.py`: Python script to load data from a CSV file into a PostgreSQL database and display the table structure.
- `airbnb.csv`: CSV file containing Airbnb listings data.
- `airbnb-queries.sql`: SQL file containing 20 queries to analyze the data.
- `.env`: Environment file storing database credentials.

## Requirements

- Docker
- Python 3
- PostgreSQL
- Python libraries: `pandas`, `sqlalchemy`, `dotenv`

## Setup

1. Clone the repository:

    ```bash
    git clone https://github.com/your-username/airbnb-analysis.git
    cd airbnb-analysis
    ```

2. Create and configure the Docker container with PostgreSQL:

    ```bash
    docker run --name airbnb-postgres -e POSTGRES_PASSWORD=yourpassword -d -p 5432:5432 postgres
    ```

3. Configure the `.env` file with your database credentials:

    ```plaintext
    DB_HOST=localhost
    DB_PORT=5432
    DB_NAME=airbnb
    DB_USER=youruser
    DB_PASSWORD=yourpassword
    ```

## Usage

1. Run the `tableandcolumns.py` script to load the data into the database:

    ```bash
    python tableandcolumns.py
    ```

    This script will:
    - Load data from the `airbnb.csv` file into a PostgreSQL table called `airbnb_listings`.
    - Display the column names of the table.

2. Execute the SQL queries in the `airbnb-queries.sql` file to analyze the data:

    Connect to the PostgreSQL database and run the queries:

    ```bash
    psql -h localhost -U youruser -d airbnb -f airbnb-queries.sql
    ```

## SQL Queries

The `airbnb-queries.sql` file contains 20 SQL queries to analyze the Airbnb data. Some of the included queries are:

- Count the total number of listings.
- Count the number of listings by neighborhood.

Add your own queries for more detailed analysis.

## Contributions

Contributions are welcome. Please open an issue or a pull request to discuss any changes you would like to make.

## License

This project is licensed under the MIT License.

# Scandiweb Ecommerce Website

This is a full-featured responsive ecommerce platform built with modern web technologies. It allows users to browse products and add them to their cart.

## Technologies Used

- **Backend**: PHP
- **Frontend**: HTML, CSS, JavaScript
- **Database**: MySQL
- **Frameworks**: Tailwind (for CSS)
- **Tools**: Composer (for PHP dependencies), npm (for JavaScript dependencies)


## Installation and Setup

1. Clone the repository:
    ```sh
    git clone https://github.com/FadyJohn10/Scandiweb-Ecommerce-website
    ```

2. Navigate to the project directory:
    ```sh
    cd Scandiweb-Ecommerce-website
    ```

3. Set up the database:
    - Create a MySQL database.
    - Configure the database connection in the `.env` file.

3. Install PHP dependencies:
    ```sh
    cd server
    composer install
    ```

4. Install JavaScript dependencies:
    ```sh
    cd ../client
    npm install
    ```

6. Run frontend:
    ```sh
    npm run dev
    ```

7. Start the server:
    ```sh
    cd ../server
    composer run-script start
    ```

8. Open your browser and navigate to `http://localhost:8080`.

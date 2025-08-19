from flask import Flask, render_template_string, request, jsonify
import mysql.connector
from mysql.connector import Error
import os
import time

app = Flask(__name__)

# Database configuration from environment variables
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'mysql-container'),
    'user': os.getenv('DB_USER', 'flask_user'),
    'password': os.getenv('DB_PASSWORD', 'flask_password'),
    'database': os.getenv('DB_NAME', 'flask_db'),
    'port': 3306
}

def get_db_connection():
    """Get database connection with retry logic"""
    max_retries = 5
    retry_count = 0
    
    while retry_count < max_retries:
        try:
            connection = mysql.connector.connect(**DB_CONFIG)
            if connection.is_connected():
                return connection
        except Error as e:
            print(f"Database connection attempt {retry_count + 1} failed: {e}")
            retry_count += 1
            time.sleep(5)
    
    raise Exception("Failed to connect to database after multiple attempts")

def init_database():
    """Initialize database with sample table"""
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        
        # Create sample table
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS users (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                email VARCHAR(100) NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)
        
        # Insert sample data if table is empty
        cursor.execute("SELECT COUNT(*) FROM users")
        count = cursor.fetchone()[0]
        
        if count == 0:
            sample_users = [
                ('John Doe', 'john@example.com'),
                ('Jane Smith', 'jane@example.com'),
                ('Bob Wilson', 'bob@example.com')
            ]
            cursor.executemany("INSERT INTO users (name, email) VALUES (%s, %s)", sample_users)
            connection.commit()
            print("Sample data inserted")
        
        cursor.close()
        connection.close()
        
    except Error as e:
        print(f"Database initialization error: {e}")

# HTML template for the main page
HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Flask App with MySQL</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 800px; margin: 0 auto; }
        .user-card { border: 1px solid #ddd; padding: 10px; margin: 10px 0; border-radius: 5px; }
        .form-group { margin: 15px 0; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input { padding: 8px; width: 200px; border: 1px solid #ddd; border-radius: 3px; }
        button { padding: 10px 20px; background-color: #007bff; color: white; border: none; border-radius: 3px; cursor: pointer; }
        button:hover { background-color: #0056b3; }
        .success { color: green; }
        .error { color: red; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Flask Application with MySQL Database</h1>
        
        <div id="status"></div>
        
        <h2>Add New User</h2>
        <form id="userForm">
            <div class="form-group">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
            </div>
            <button type="submit">Add User</button>
        </form>
        
        <h2>Users in Database</h2>
        <div id="users"></div>
        <button onclick="loadUsers()">Refresh Users</button>
    </div>

    <script>
        function loadUsers() {
            fetch('/api/users')
                .then(response => response.json())
                .then(data => {
                    const usersDiv = document.getElementById('users');
                    if (data.users && data.users.length > 0) {
                        usersDiv.innerHTML = data.users.map(user => 
                            `<div class="user-card">
                                <strong>ID:</strong> ${user[0]}<br>
                                <strong>Name:</strong> ${user[1]}<br>
                                <strong>Email:</strong> ${user[2]}<br>
                                <strong>Created:</strong> ${user[3]}
                            </div>`
                        ).join('');
                    } else {
                        usersDiv.innerHTML = '<p>No users found</p>';
                    }
                })
                .catch(error => {
                    document.getElementById('users').innerHTML = `<p class="error">Error loading users: ${error}</p>`;
                });
        }

        document.getElementById('userForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            
            fetch('/api/users', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    name: formData.get('name'),
                    email: formData.get('email')
                })
            })
            .then(response => response.json())
            .then(data => {
                const status = document.getElementById('status');
                if (data.success) {
                    status.innerHTML = '<p class="success">User added successfully!</p>';
                    this.reset();
                    loadUsers();
                } else {
                    status.innerHTML = `<p class="error">Error: ${data.error}</p>`;
                }
            })
            .catch(error => {
                document.getElementById('status').innerHTML = `<p class="error">Error: ${error}</p>`;
            });
        });

        // Load users on page load
        loadUsers();
    </script>
</body>
</html>
"""

@app.route('/')
def index():
    return render_template_string(HTML_TEMPLATE)

@app.route('/health')
def health_check():
    try:
        connection = get_db_connection()
        connection.close()
        return jsonify({
            'status': 'healthy',
            'database': 'connected',
            'message': 'Flask app is running and database is accessible'
        })
    except Exception as e:
        return jsonify({
            'status': 'unhealthy',
            'database': 'disconnected',
            'error': str(e)
        }), 500

@app.route('/api/users', methods=['GET'])
def get_users():
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT id, name, email, created_at FROM users ORDER BY created_at DESC")
        users = cursor.fetchall()
        cursor.close()
        connection.close()
        
        return jsonify({
            'success': True,
            'users': users
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/api/users', methods=['POST'])
def add_user():
    try:
        data = request.get_json()
        name = data.get('name')
        email = data.get('email')
        
        if not name or not email:
            return jsonify({
                'success': False,
                'error': 'Name and email are required'
            }), 400
        
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("INSERT INTO users (name, email) VALUES (%s, %s)", (name, email))
        connection.commit()
        cursor.close()
        connection.close()
        
        return jsonify({
            'success': True,
            'message': 'User added successfully'
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

if __name__ == '__main__':
    print("Starting Flask application...")
    print(f"Database Config: {DB_CONFIG}")
    
    # Initialize database on startup
    try:
        init_database()
        print("Database initialized successfully")
    except Exception as e:
        print(f"Database initialization failed: {e}")
    
    app.run(host='0.0.0.0', port=5000, debug=True)

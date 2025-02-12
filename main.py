from flask import Flask, request, render_template_string
import sqlite3

app = Flask(__name__)

# In-memory SQLite database for demonstration purposes
def init_db():
    conn = sqlite3.connect(':memory:')
    cursor = conn.cursor()
    cursor.execute('CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT, password TEXT)')
    cursor.execute("INSERT INTO users (username, password) VALUES ('admin', 'admin123')")
    conn.commit()
    return conn

conn = init_db()

@app.route('/')
def index():
    return 'Welcome to the Vulnerable App!'

# SQL Injection Vulnerability
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        # Vulnerable SQL query
        query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"
        cursor = conn.cursor()
        cursor.execute(query)
        user = cursor.fetchone()

        if user:
            return f'Welcome, {user[1]}!'
        else:
            return 'Invalid credentials!'
    return '''
        <form method="post">
            Username: <input type="text" name="username"><br>
            Password: <input type="password" name="password"><br>
            <input type="submit" value="Login">
        </form>
    '''

# Cross-Site Scripting (XSS) Vulnerability
@app.route('/search')
def search():
    query = request.args.get('q', '')
    # Vulnerable to XSS
    return render_template_string(f'<h1>Search Results for: {query}</h1>')

# Insecure Direct Object Reference (IDOR) Vulnerability
@app.route('/profile/<int:user_id>')
def profile(user_id):
    cursor = conn.cursor()
    cursor.execute(f'SELECT * FROM users WHERE id = {user_id}')
    user = cursor.fetchone()

    if user:
        return f'Profile of {user[1]}'
    else:
        return 'User not found!'

if __name__ == '__main__':
    app.run(debug=True)
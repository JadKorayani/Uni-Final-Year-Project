# Import needed libraries
from flask import g
import sqlite3

# Database path
DATABASE = 'C:/github_fyp/Uni-Final-Year-Project/backend/database.db'


# Connect to database function
def connect_db():
    """Create and return a new database connection."""
    sql = sqlite3.connect(DATABASE)
    sql.row_factory = sqlite3.Row  # This makes the query results accessible by column name
    return sql


# Get database function
def get_db():
    """Get or create a database connection for the current request."""
    if not hasattr(g, 'sqlite_db'):  
        g.sqlite_db = connect_db()
    return g.sqlite_db
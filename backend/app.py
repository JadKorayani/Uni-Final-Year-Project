# Import libraries 
from flask import Flask, jsonify, request, g, render_template, url_for, redirect, session
from databse import get_db
from werkzeug.security import generate_password_hash, check_password_hash
import os

# Initialize a Flask application instance
app = Flask(__name__)
# Generating a secure secret key
app.secret_key = os.urandom(24)  
# Only send cookie over HTTPS
app.config['SESSION_COOKIE_SECURE'] = True
# Make sure sessions are not permanent
app.config['SESSION_PERMANENT'] = False  


# Close database to avoid data leaks
@app.teardown_appcontext
def close_db(error):
    """Closes the database connection automatically at the end of the request cycle.
    This function is triggered automatically when the Flask application context is torn down. 
    It checks if a database connection exists and closes it to prevent any potential data leaks or holding unused resources."""

    if hasattr(g, 'sqlite_db'):
        g.sqlite_db.close() 


# Signup route
@app.route('/signup', methods=['POST'])
def signup():
    """Handles the signup process for new users via a web form.
    This function supports both GET and POST methods. On a POST request, it processes the incoming JSON data to register a new user. 
    It checks for existing user emails, hashes the password for security, and inserts the new user data into the database. 
    If the email already exists, it returns an error. Successfully registered users are logged in automatically."""

    if request.method == 'POST':
        # Access JSON data from the request
        data = request.json

        db = get_db()
        existing_user = db.execute(
            'SELECT email FROM users WHERE email = ?',
            [data['Email']]
        ).fetchone()

        if existing_user:
            # Return an error message in JSON format
            return jsonify({'error': 'User already exists'}), 400

        # Hash the password
        hashed_password = generate_password_hash(data['password'])

        # Insert data into the database with the hashed password
        db.execute(
            'INSERT INTO Users (Name, FamilyName, Email, AllergyInformation, PasswordHash) VALUES (?, ?, ?, ?, ?)',
            [data['first_name'], data['last_name'], data['Email'], '', hashed_password]
        )
        db.commit()

        # Log in the user by setting the session variables
        session['Email'] = data['Email']
        
        # Return a success response
        return jsonify({'message': 'User registered successfully'}), 200

    # For a GET request, or any other method, you might want to return a different response
    return jsonify({'message': 'Send POST request with signup data'}), 405


# user_details route
@app.route('/user_details', methods=['GET'])
def user_details():
    """Retrieves detailed user information for a specified email via a GET request.
    This endpoint expects an email as a query parameter ('user_id'). 
    It fetches basic user details like UserID, Name, FamilyName, and Email from the Users table. 
    If the user exists, it also retrieves related allergy information by joining the UserAllergyRelationship and Allergens tables. 
    The function constructs a JSON response with user details and a list of allergies if applicable. 
    If no user matches the provided email, it returns a 'User not found' error.
    This function is useful for clients needing comprehensive user profiles including allergy details."""

    # Access database
    db = get_db()
    # Request user_id from the frontend through the API call
    email = request.args.get('user_id')

    # Execute sql query to get UserID, Name, FamilyName, Email from database
    user = db.execute('SELECT UserID, Name, FamilyName, Email FROM Users WHERE Email = ?', [email]).fetchone()

    if user:
        # Fetch the user's allergies by joining the UserAllergyRelationship and Allergens tables
        allergies = db.execute('''SELECT Allergens.Name 
                                  FROM UserAllergyRelationship 
                                  JOIN Allergens ON UserAllergyRelationship.AllergenID = Allergens.AllergenID 
                                  WHERE UserID = ?''', [user['UserID']]).fetchall()

        # Convert the list of rows into a list of allergy names
        allergy_names = [allergy['Name'] for allergy in allergies]

         # Construct and return a successful JSON response
        response = {
                "success": True,
                "message": "User details successfully retreived!",
                "user_id": user['UserID'],
                "email": user['Email'],
                "first_name": user['Name'],
                "last_name": user['FamilyName'],
                "allergy": allergy_names
            }
        return jsonify(response), 200
    else:
        return 'User not found', 404


# login route
@app.route('/login', methods=['POST'])
def login():
    """Handles user login via a POST request, validating email and password.
    On receiving a POST request with email and password in JSON format, this function checks the credentials against the database. 
    If the credentials are valid, it sets session variables for the user and returns a success message with user details. 
    If the credentials do not match, it returns an error message indicating an invalid login attempt."""

    if request.method == 'POST':
        # Get JSON data from the request
        data = request.get_json()  # This parses the JSON data sent with the request
        
        # Access the email and password from the parsed JSON data
        email = data['email']
        password = data['password']
       
        db = get_db()
        # Execute the query to find the user by email
        user = db.execute('SELECT * FROM Users WHERE Email = ?', (email,)).fetchone()
       
        # Check if the user exists and the password is correct
        if user and check_password_hash(user['PasswordHash'], password):
            # Set user information in the session
            session['user_id'] = user['UserID']
            session['Email'] = user['Email']

            # Construct and return a successful JSON response
            response = {
                "success": True,
                "message": "Login successful",
                "user_id": user['UserID'],
                "email": user['Email']
            }
            
            return jsonify(response), 200
        else:
            # Construct and return a JSON response for failed login
            response = {
                "success": False,
                "message": "Invalid email or password"
            }
            return jsonify(response), 401


# get_allergens route
@app.route('/get_allergens', methods=['GET'])
def get_allergens():
    """Fetches and returns a list of all allergens from the database via a GET request.
    This endpoint retrieves the AllergenID and Name for each allergen stored in the Allergens table and returns them as a list of dictionaries. 
    Useful for clients needing to display or utilize allergen information."""

    # Access database
    db = get_db()
    # Execute SQL query to get AllergenID and Name from database
    allergens = db.execute('SELECT AllergenID, Name FROM Allergens').fetchall()
    return [{'AllergenID': allergen['AllergenID'], 'Name': allergen['Name']} for allergen in allergens]


# save_allergy route
@app.route('/save_allergy', methods=['POST'])
def save_allergy():
    """Adds a user's allergy information to the database via a POST request.
    Accepts JSON data containing a user's email (UserID) and an allergen ID (AllergenID). 
    If the specified user is found, it inserts a record linking the user and allergen into the UserAllergyRelationship table. 
    Returns a success message if the allergy is added successfully, and instructs to use POST if another method is attempted."""

    if request.method == 'POST':
        # Access JSON data from the request
        data = request.json
        # Get the UserID from the frontend through API call
        userID = data['UserID']
        # Access the database
        db = get_db()
        # Get the 
        user_id = db.execute('SELECT UserID FROM Users WHERE Email = ?', (userID,)).fetchone()

        if user_id:
            # Extract the UserID from the tuple
            user_id = user_id[0]
            # Insert data into the database with the hashed password
            db.execute(
                'INSERT INTO UserAllergyRelationship (UserID, AllergenID) VALUES (?, ?)',
                [user_id, data['AllergenID']]
                )
            db.commit()
            # Return a success response
            return jsonify({'message': 'Allergy added successfully'}), 200

    # For a GET request, or any other method, you might want to return a different response
    return jsonify({'message': 'Send POST request with signup data'}), 405


# allergy_information route
@app.route('/allergy_information', methods=['GET'])
def allergy_information():
    """Retrieves comprehensive allergy information for a specified user via a GET request.
    This function uses an email provided as a 'user_id' query parameter to fetch the user's ID. 
    If the user exists, it retrieves a complete list of all allergens and the allergens specifically selected by the user, 
    marking each allergen as selected or not in the response. 
    Returns detailed allergen data if the user is found, or an error message if the user is not found or not specified."""

    # Access the database
    db = get_db()
    # Get the user_id from the frontend through API call
    email = request.args.get('user_id')
    
    if email:
        # Execute SQL query to get UserID from database
        user = db.execute('SELECT UserID FROM Users WHERE Email = ?', [email]).fetchone()
        if user:
            # Fetch all allergens
            allergens = db.execute('SELECT AllergenID, Name FROM Allergens').fetchall()
            allergens_list = [{'AllergenID': allergen['AllergenID'], 'Name': allergen['Name']} for allergen in allergens]

            # Fetch user-specific selected allergens
            selected_allergens = db.execute(
                'SELECT AllergenID FROM UserAllergyRelationship WHERE UserID = ?', [user['UserID']]
            ).fetchall()
            selected_allergens_ids = [allergen['AllergenID'] for allergen in selected_allergens]

            # Add a flag to each allergen indicating whether it's selected by the user
            for allergen in allergens_list:
                allergen['Selected'] = allergen['AllergenID'] in selected_allergens_ids

            return jsonify(allergens_list)
        else:
            return jsonify({'error': 'User not found'}), 404
    else:
        # If no user is logged in, or if you're handling this differently in your Flutter app,
        # you might want to return just the list of allergens or handle the error appropriately.
        return jsonify({'error': 'User not authenticated'}), 401


# restaurants route
@app.route('/restaurants')
def restaurants():
    """Retrieves and returns a list of all restaurants along with their IDs from the database.
    Fetches restaurant names and IDs from the Restaurants table and packages them into separate lists, which are then returned together as JSON data."""

    # Access the database
    db = get_db()
    restaurant_query = db.execute('SELECT Name, RestaurantID FROM Restaurants').fetchall()
    restaurants = [restaurant['Name'] for restaurant in restaurant_query]
    restaurants_id = [restaurant['RestaurantID'] for restaurant in restaurant_query]

    return jsonify(restaurants, restaurants_id)


# get_restaurant_details route
def get_restaurant_details(restaurant_id, methods=['GET']): 
    """ Get restaurants details from the database. """
    db = get_db()
    restaurant_details = db.execute(
        'SELECT * FROM Restaurants WHERE RestaurantID = ?',
        [restaurant_id]
    ).fetchone()
    return jsonify(restaurant_details)


# item_menu route
@app.route('/item_menu/<int:menu_item_id>')
def item_menu(menu_item_id):
    db = get_db()
    menu_item = db.execute('SELECT * FROM MenuItems WHERE MenuItemID = ?', (menu_item_id,)).fetchone()
    
    if menu_item is None:
        return 'Menu item not found', 404
    
    # Fetch the restaurant details as well if needed for the page title or breadcrumb
    restaurant = db.execute('SELECT * FROM Restaurants WHERE RestaurantID = ?', (menu_item['RestaurantID'],)).fetchone()
    
    return render_template('item_menu.html', menu_item=menu_item, restaurant=restaurant)


# selected_restaurant route
@app.route('/selected_restaurant', methods=['GET'])
def selected_restaurant():
    """Retrieves a list of menu items from a specified restaurant that are safe for a user with allergies via a GET request.
    This function uses an email to identify the user and a restaurant ID to specify the establishment. 
    It first fetches the user's allergy IDs, then finds related ingredient IDs that the user must avoid. 
    It queries the restaurant's menu items to exclude those containing the identified allergenic ingredients. 
    Returns a list of safe menu items for the user, or all menu items if no allergenic ingredients are found."""

    # Acess the database
    db = get_db()
    # Get the email from the frontend through API call
    email = request.args.get('email')
    # Get the restID from the frontend through API call
    restaurant_id = request.args.get('restID')
    # Execute SQL query to get UserID from database
    user = db.execute('SELECT UserID FROM Users WHERE Email = ?', [email]).fetchone()
    # Execute SQL query to get AllergenID from databas
    allergies = db.execute('SELECT AllergenID FROM UserAllergyRelationship WHERE UserID = ?', [user['UserID']]).fetchall()
    allergen_ids = [allergy['AllergenID'] for allergy in allergies]
    # Execute SQL IngredientID to get UserID from databas  
    ingredients = db.execute('SELECT IngredientID FROM AllergenIngredientRelationship WHERE AllergenID IN ({seq})'.format(seq=','.join(['?']*len(allergen_ids))), allergen_ids).fetchall()
    ingredient_ids = [ingredient['IngredientID'] for ingredient in ingredients]

    if ingredient_ids:
        # Modify the query to select only the item names
        menu_items = db.execute('''SELECT mi.Name FROM MenuItems mi
                                   WHERE mi.RestaurantID = ? AND 
                                   NOT EXISTS (SELECT 1 FROM MenuItemIngredients mii 
                                               WHERE mii.MenuItemID = mi.MenuItemID 
                                               AND mii.IngredientID IN ({seq}))
                                   '''.format(seq=','.join(['?']*len(ingredient_ids))), [restaurant_id] + ingredient_ids).fetchall()
    else:
        menu_items = db.execute('SELECT Name FROM MenuItems WHERE RestaurantID = ?', [restaurant_id]).fetchall()

    # Extract the item names from the rows
    item_names = [item['Name'] for item in menu_items]

    return jsonify(menu_items=item_names)


@app.after_request
def add_security_headers(response):
    """Adds security-related headers to all responses to enhance privacy and security.
    This function is executed after every request. 
    It modifies the response to include headers that prevent caching of the response data by browsers or proxies, 
    ensuring that sensitive data is not stored inadvertently. 
    Specifically, it sets 'Cache-Control', 'Pragma', and 'Expires' headers to values that disable caching."""

    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate, public, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
    return response


# logout route
@app.route('/logout')
def logout():
    # Clear specific session keys
    session.pop('email', None)
    session.pop('first_name', None)
    # Optionally, clear the entire session
    # session.clear()
    return redirect(url_for('login'))


# Start the Flask server on all interfaces at port 8080 if run as the main program
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)  
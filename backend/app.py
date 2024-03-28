from flask import Flask, request, g, render_template, url_for, redirect, session, make_response, flash
from databse import get_db
from werkzeug.security import generate_password_hash, check_password_hash
from functools import wraps
import os


app = Flask(__name__)

# Set a secret key for sessions
app.secret_key = os.urandom(24)  # Generating a secure secret key

@app.teardown_appcontext
def close_db(error):
    if hasattr(g, 'sqlite_db'):
        g.sqlite_db.close()   # to avoid data leaks and 


@app.route('/')
def index():
    return ('test')

@app.route('/welcome')
def welcome():
    return render_template('welcome.html')


@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        db = get_db()
        existing_user = db.execute('SELECT email FROM users WHERE email = ?', [request.form['email']]).fetchone()

        if existing_user:
            return render_template('signup.html', error='User already exists')

        # Hash the password
        hashed_password = generate_password_hash(request.form['password'])

        # Insert data into the database with the hashed password
        db.execute('INSERT INTO Users (Name, FamilyName, Email, AllergyInformation, PasswordHash) VALUES (?, ?, ?, ?, ?)',
                   [request.form['first_name'], request.form['last_name'], request.form['email'], '', hashed_password])
        db.commit()

        # Log in the user by setting the session variables
        session['email'] = request.form['email']
        
        return redirect(url_for('allergy_information'))
    return render_template('signup.html')


@app.route('/user_details')
def user_details():
    if 'email' not in session:
        return redirect(url_for('login'))
    email = session.get('email')
    if not email:
        return redirect(url_for('login'))

    db = get_db()
    user = db.execute('SELECT UserID, Name, FamilyName FROM Users WHERE Email = ?', [email]).fetchone()

    if user:
        # Fetch the user's allergies by joining the UserAllergyRelationship and Allergens tables
        allergies = db.execute('''SELECT Allergens.Name 
                                  FROM UserAllergyRelationship 
                                  JOIN Allergens ON UserAllergyRelationship.AllergenID = Allergens.AllergenID 
                                  WHERE UserID = ?''', [user['UserID']]).fetchall()

        # Convert the list of rows into a list of allergy names
        allergy_names = [allergy['Name'] for allergy in allergies]

        return render_template('user_details.html', 
                               first_name=user['Name'], 
                               last_name=user['FamilyName'], 
                               allergies=allergy_names)
    else:
        return 'User not found', 404


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        
        db = get_db()
        user = db.execute('SELECT * FROM Users WHERE Email = ?', (email,)).fetchone()
        
        if user and check_password_hash(user['PasswordHash'], password):
            session['user_id'] = user['UserID']
            session['email'] = user['Email']  # Using 'email' to be consistent with your database and session checks
            
            # Redirect to a different page based on the user's role (not considering IsAdmin)
            return redirect(url_for('user_details'))
        else:
            flash('Invalid email or password')
    return render_template('login.html')


'''@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        
        db = get_db()
        user = db.execute('SELECT * FROM Users WHERE Email = ?', (email,)).fetchone()
        
        if user and check_password_hash(user['PasswordHash'], password):
            session['user_id'] = user['UserID']
            session['email'] = user['Email']  # Using 'email' to be consistent with your database and session checks
            
            # Assuming you added an IsAdmin column
            session['is_admin'] = user['IsAdmin']


            
            # Redirect to a different page based on whether the user is an admin
            if session['is_admin']:
                return redirect(url_for('admin_dashboard'))
            else:
                return redirect(url_for('index'))
        else:
            flash('Invalid email or password')
    return render_template('login.html')'''



def get_allergens():
    db = get_db()
    allergens = db.execute('SELECT AllergenID, Name FROM Allergens').fetchall()
    return allergens


@app.route('/allergy_information', methods=['GET', 'POST'])
def allergy_information():
    if request.method == 'POST':
        selected_allergens = request.form.getlist('allergies')
        
        email = session.get('email')
        if not email:
            return redirect(url_for('login'))
        
        db = get_db()
        user = db.execute('SELECT UserID FROM Users WHERE Email = ?', [email]).fetchone()
        
        # Clear existing user-allergen relationships
        db.execute('DELETE FROM UserAllergyRelationship WHERE UserID = ?', [user['UserID']])
        
        # Insert new relationships
        for allergen_id in selected_allergens:
            db.execute('INSERT INTO UserAllergyRelationship (UserID, AllergenID) VALUES (?, ?)', 
                       [user['UserID'], allergen_id])
        
        db.commit()
        
        return redirect(url_for('user_details'))
    else:
        allergens = get_allergens()
        return render_template('allergy_information.html', allergens=allergens)




@app.route('/profile')
def profile():
    # Assuming user's email is stored in session after login/signup
    user_email = session.get('email')
    if user_email:
        db = get_db()
        user = db.execute('SELECT * FROM Users WHERE Email = ?', [user_email]).fetchone()
        if user:
            return render_template('profile.html', user=user)
        else:
            # Handle case where user is not found (e.g., redirect to login)
            return redirect(url_for('login'))
    else:
        # No email in session, redirect to login
        return redirect(url_for('login'))


@app.route('/nav_options')
def nav_options():
    return render_template('nav_options.html')

@app.route('/restaurants')
def restaurants():
    db = get_db()
    # Fetch all restaurants from the database
    all_restaurants = db.execute('SELECT * FROM Restaurants').fetchall()
    return render_template('restaurants.html', restaurants=all_restaurants)

def get_restaurant_details(restaurant_id):
    db = get_db()
    restaurant_details = db.execute(
        'SELECT * FROM Restaurants WHERE RestaurantID = ?',
        [restaurant_id]
    ).fetchone()
    return restaurant_details


@app.route('/item_menu/<int:menu_item_id>')
def item_menu(menu_item_id):
    db = get_db()
    menu_item = db.execute('SELECT * FROM MenuItems WHERE MenuItemID = ?', (menu_item_id,)).fetchone()
    
    if menu_item is None:
        return 'Menu item not found', 404
    
    # Fetch the restaurant details as well if needed for the page title or breadcrumb
    restaurant = db.execute('SELECT * FROM Restaurants WHERE RestaurantID = ?', (menu_item['RestaurantID'],)).fetchone()
    
    return render_template('item_menu.html', menu_item=menu_item, restaurant=restaurant)



@app.route('/selected_restaurant/<int:restaurant_id>')
def selected_restaurant(restaurant_id):
    user_email = session.get('email')
    if not user_email:
        # Handle case where user is not logged in or session expired
        return redirect(url_for('login'))

    db = get_db()
    user = db.execute('SELECT UserID FROM Users WHERE Email = ?', [user_email]).fetchone()

    # Step 1: Fetch user's allergies
    allergies = db.execute('''SELECT AllergenID FROM UserAllergyRelationship WHERE UserID = ?''', [user['UserID']]).fetchall()
    allergen_ids = [allergy['AllergenID'] for allergy in allergies]

    # Step 2: Identify ingredients linked to these allergens
    ingredients = db.execute('''SELECT IngredientID FROM AllergenIngredientRelationship WHERE AllergenID IN ({seq})'''.format(seq=','.join(['?']*len(allergen_ids))), allergen_ids).fetchall()
    ingredient_ids = [ingredient['IngredientID'] for ingredient in ingredients]

    # Step 3: Filter menu items based on the identified ingredients
    if ingredient_ids:
        menu_items = db.execute('''SELECT mi.* FROM MenuItems mi
                                   WHERE mi.RestaurantID = ? AND 
                                   NOT EXISTS (SELECT 1 FROM MenuItemIngredients mii 
                                               WHERE mii.MenuItemID = mi.MenuItemID 
                                               AND mii.IngredientID IN ({seq}))
                                   '''.format(seq=','.join(['?']*len(ingredient_ids))), [restaurant_id] + ingredient_ids).fetchall()
    else:
        # If user has no allergies or no ingredients are associated with their allergies, fetch all menu items
        menu_items = db.execute('SELECT * FROM MenuItems WHERE RestaurantID = ?', [restaurant_id]).fetchall()

    restaurant_details = get_restaurant_details(restaurant_id)

    return render_template('selected_restaurant.html', restaurant=restaurant_details, menu_items=menu_items)


@app.route('/about')
def about():
    return render_template('about.html')

#@app.route('/item_menu')
#def item_menu():
#    return render_template('item_menu.html')


@app.route('/contact')
def contact():
    return render_template('contact.html')

@app.after_request
def add_security_headers(response):
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate, public, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
    return response

@app.route('/logout')
def logout():
    # Clear specific session keys
    session.pop('email', None)
    session.pop('first_name', None)
    # Optionally, clear the entire session
    # session.clear()
    return redirect(url_for('login'))


# Admin related
def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        # Check if 'is_admin' is in session and is True
        if 'is_admin' not in session or not session['is_admin']:
            flash('You need to be an admin to view this page.')
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

@app.route('/admin/users')
@admin_required  # Ensure this route is protected so only admins can access it
def admin_users():
    db = get_db()
    users = db.execute('SELECT UserID, Name, Email FROM Users').fetchall()
    return render_template('admin/admin_users.html', users=users)


@app.route('/admin/admin_restaurants')
@admin_required
def admin_restaurants():
    db = get_db()
    restaurants = db.execute('SELECT * FROM Restaurants').fetchall()
    return render_template('admin/admin_restaurants.html', restaurants=restaurants)


@app.route('/admin/restaurants/add', methods=['GET', 'POST'])
@admin_required
def add_restaurant():
    if request.method == 'POST':
        name = request.form['name']
        address = request.form['address']
        db = get_db()
        db.execute('INSERT INTO Restaurants (Name, Address) VALUES (?, ?)', (name, address))
        db.commit()
        return redirect(url_for('admin_restaurants'))
    return render_template('admin/add_restaurant.html')

@app.route('/admin/restaurants/edit/<int:id>', methods=['GET', 'POST'])
@admin_required
def edit_restaurant(id):
    db = get_db()
    if request.method == 'POST':
        name = request.form['name']
        address = request.form['address']
        db.execute('UPDATE Restaurants SET Name = ?, Address = ? WHERE RestaurantID = ?', (name, address, id))
        db.commit()
        return redirect(url_for('admin_restaurants'))
    restaurant = db.execute('SELECT * FROM Restaurants WHERE RestaurantID = ?', (id,)).fetchone()
    return render_template('admin/edit_restaurant.html', restaurant=restaurant)


@app.route('/admin/restaurants/delete/<int:id>', methods=['GET', 'POST'])
@admin_required
def delete_restaurant(id):
    db = get_db()
    restaurant = db.execute('SELECT * FROM Restaurants WHERE RestaurantID = ?', (id,)).fetchone()
    
    if request.method == 'POST':
        db.execute('DELETE FROM Restaurants WHERE RestaurantID = ?', (id,))
        db.commit()
        return redirect(url_for('admin_restaurants'))
    
    return render_template('admin/delete_restaurant.html', restaurant=restaurant)


@app.route('/admin/admin_dashboard')
@admin_required
def admin_dashboard():
    # Admin dashboard logic here
    return render_template('/admin/admin_dashboard.html')


if __name__ == '__main__':
    app.run(debug=True)
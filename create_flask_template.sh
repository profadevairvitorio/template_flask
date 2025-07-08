#!/bin/bash

APP_NAME="flask_template"

echo "Criando a estrutura de diretórios e arquivos para $APP_NAME..."

mkdir -p "$APP_NAME/app/models"
mkdir -p "$APP_NAME/app/routes"
mkdir -p "$APP_NAME/app/forms"
mkdir -p "$APP_NAME/app/services"
mkdir -p "$APP_NAME/app/builders"
mkdir -p "$APP_NAME/app/templates"
mkdir -p "$APP_NAME/app/static/css"
mkdir -p "$APP_NAME/app/static/js"

cat << EOF > "$APP_NAME/run.py"
from app import create_app

app = create_app()

if __name__ == '__main__':
    app.run(debug=True)
EOF

cat << EOF > "$APP_NAME/requirements.txt"
Flask
SQLAlchemy
Flask-SQLAlchemy
Flask-WTF
WTForms
EOF

cat << EOF > "$APP_NAME/.gitignore"
venv/
*.pyc
__pycache__/
.env
site.db
*.sqlite3
EOF

cat << EOF > "$APP_NAME/README.md"
# Your Flask App Template

This is a blank Flask application template with the following features:

- **Database:** SQLite with SQLAlchemy.
- **Structure:**
    - Models
    - Routes (Views)
    - Forms
    - Services (Business Logic)
    - Builders (Object construction)
- **Templates:** Base HTML and example pages.
- **Static Files:** CSS and JavaScript.

## Getting Started

1.  **Clone this repository** or use it as a template on GitHub.
2.  **Create and activate a virtual environment:**
    \`\`\`bash
    python -m venv venv
    source venv/bin/activate
    \`\`\`
3.  **Install dependencies:**
    \`\`\`bash
    pip install -r requirements.txt
    \`\`\`
4.  **Run the application:**
    \`\`\`bash
    python run.py
    \`\`\`
5.  **Access in your browser:** `http://127.0.0.1:5000/`
EOF

cat << EOF > "$APP_NAME/LICENSE"
MIT License

Copyright (c) 2025 Your Name (or Company Name)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF


cat << EOF > "$APP_NAME/app/__init__.py"
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from .config import Config

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)

    with app.app_context():
        from .models import user  # Exemplo de importação de modelo
        db.create_all() # Cria as tabelas do banco de dados

        # Registrar blueprints (rotas)
        from .routes.main_routes import main_bp
        app.register_blueprint(main_bp)

    return app
EOF

cat << EOF > "$APP_NAME/app/config.py"
import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'uma-chave-secreta-muito-segura'
    SQLALCHEMY_DATABASE_URI = 'sqlite:///site.db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
EOF

cat << EOF > "$APP_NAME/app/database.py"
# app/database.py (Opcional, se você quiser centralizar a instância do db aqui)
# from flask_sqlalchemy import SQLAlchemy
# db = SQLAlchemy()
# No nosso caso, 'db' já está em app/__init__.py
EOF

# 4. Cria os arquivos de models
cat << EOF > "$APP_NAME/app/models/__init__.py"
# Este arquivo indica que 'models' é um pacote Python.
EOF

cat << EOF > "$APP_NAME/app/models/user.py"
from app import db

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)

    def __repr__(self):
        return f'<User {self.username}>'
EOF

cat << EOF > "$APP_NAME/app/routes/__init__.py"
# Este arquivo indica que 'routes' é um pacote Python.
EOF

cat << EOF > "$APP_NAME/app/routes/main_routes.py"
from flask import Blueprint, render_template, request, redirect, url_for, flash
from app.forms.user_forms import UserForm
from app.services.user_service import UserService

main_bp = Blueprint('main', __name__)

@main_bp.route('/')
def index():
    return render_template('index.html', title='Início')

@main_bp.route('/register', methods=['GET', 'POST'])
def register():
    form = UserForm()
    if form.validate_on_submit():
        username = form.username.data
        email = form.email.data
        try:
            UserService.create_user(username, email)
            flash('Usuário registrado com sucesso!', 'success')
            return redirect(url_for('main.index'))
        except Exception as e:
            flash(f'Erro ao registrar usuário: {e}', 'danger')
    return render_template('register.html', title='Registrar', form=form)
EOF

cat << EOF > "$APP_NAME/app/forms/__init__.py"
# Este arquivo indica que 'forms' é um pacote Python.
EOF

cat << EOF > "$APP_NAME/app/forms/user_forms.py"
from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField
from wtforms.validators import DataRequired, Email, Length

class UserForm(FlaskForm):
    username = StringField('Nome de Usuário', validators=[DataRequired(), Length(min=2, max=20)])
    email = StringField('Email', validators=[DataRequired(), Email()])
    submit = SubmitField('Registrar')
EOF

cat << EOF > "$APP_NAME/app/services/__init__.py"
# Este arquivo indica que 'services' é um pacote Python.
EOF

cat << EOF > "$APP_NAME/app/services/user_service.py"
from app import db
from app.models.user import User

class UserService:
    @staticmethod
    def create_user(username, email):
        existing_user = User.query.filter_by(username=username).first()
        if existing_user:
            raise ValueError("Nome de usuário já existe.")
        existing_email = User.query.filter_by(email=email).first()
        if existing_email:
            raise ValueError("Email já registrado.")

        user = User(username=username, email=email)
        db.session.add(user)
        db.session.commit()
        return user

    @staticmethod
    def get_all_users():
        return User.query.all()

    @staticmethod
    def get_user_by_id(user_id):
        return User.query.get(user_id)
EOF

cat << EOF > "$APP_NAME/app/builders/__init__.py"
# Este arquivo indica que 'builders' é um pacote Python.
EOF

cat << EOF > "$APP_NAME/app/builders/user_builder.py"
from app.models.user import User

class UserBuilder:
    def __init__(self):
        self._username = None
        self._email = None

    def with_username(self, username):
        self._username = username
        return self

    def with_email(self, email):
        self._email = email
        return self

    def build(self):
        if not self._username or not self._email:
            raise ValueError("Username and email are required to build a User.")
        return User(username=self._username, email=self._email)

# Exemplo de uso:
# from app.builders.user_builder import UserBuilder
# user = UserBuilder().with_username("novo_usuario").with_email("email@example.com").build()
EOF

cat << EOF > "$APP_NAME/app/templates/base.html"
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ title }} - Minha Aplicação Flask</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='css/style.css') }}">
</head>
<body>
    <header>
        <nav>
            <a href="{{ url_for('main.index') }}">Home</a>
            <a href="{{ url_for('main.register') }}">Registrar</a>
        </nav>
    </header>
    <main>
        {% with messages = get_flashed_messages(with_categories=true) %}
            {% if messages %}
                <div class="flashes">
                    {% for category, message in messages %}
                        <div class="alert alert-{{ category }}">{{ message }}</div>
                    {% endfor %}
                </div>
            {% endif %}
        {% endwith %}
        {% block content %}{% endblock %}
    </main>
    <footer>
        <p>&copy; 2025 Minha Aplicação Flask</p>
    </footer>
    <script src="{{ url_for('static', filename='js/script.js') }}"></script>
</body>
</html>
EOF

cat << EOF > "$APP_NAME/app/templates/index.html"
{% extends "base.html" %}

{% block content %}
    <h1>Bem-vindo à sua Aplicação Flask!</h1>
    <p>Este é um template blank para começar seu projeto.</p>
{% endblock %}
EOF

cat << EOF > "$APP_NAME/app/templates/register.html"
{% extends "base.html" %}
{% block content %}
    <h2>Registrar Novo Usuário</h2>
    <form method="POST" action="">
        {{ form.hidden_tag() }}
        <div>
            {{ form.username.label }}<br>
            {{ form.username(size=32) }}<br>
            {% for error in form.username.errors %}
                <span style="color: red;">[{{ error }}]</span>
            {% endfor %}
        </div>
        <div>
            {{ form.email.label }}<br>
            {{ form.email(size=32) }}<br>
            {% for error in form.email.errors %}
                <span style="color: red;">[{{ error }}]</span>
            {% endfor %}
        </div>
        <div>
            {{ form.submit() }}
        </div>
    </form>
{% endblock %}
EOF

cat << EOF > "$APP_NAME/app/static/css/style.css"
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: #f4f4f4;
    color: #333;
}

header {
    background-color: #333;
    color: white;
    padding: 1em 0;
    text-align: center;
}

nav a {
    color: white;
    margin: 0 15px;
    text-decoration: none;
}

main {
    padding: 20px;
    max-width: 800px;
    margin: 20px auto;
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

footer {
    text-align: center;
    padding: 1em 0;
    background-color: #333;
    color: white;
    position: fixed;
    bottom: 0;
    width: 100%;
}

.alert {
    padding: 10px;
    margin-bottom: 10px;
    border-radius: 5px;
}

.alert-success {
    background-color: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}

.alert-danger {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}
EOF

cat << EOF > "$APP_NAME/app/static/js/script.js"
document.addEventListener('DOMContentLoaded', function() {
    console.log('JavaScript carregado!');
});
EOF

echo "Estrutura de diretórios e arquivos criada com sucesso em ./$APP_NAME!"
echo "Agora você pode 'cd $APP_NAME' e seguir os passos para iniciar a aplicação."
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

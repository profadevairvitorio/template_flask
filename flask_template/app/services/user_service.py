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

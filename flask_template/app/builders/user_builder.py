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

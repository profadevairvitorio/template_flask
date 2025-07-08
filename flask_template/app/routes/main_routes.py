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

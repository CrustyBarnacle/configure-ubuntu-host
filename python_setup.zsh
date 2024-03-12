# python pip pipx poetry
echo 'Installing pip/x, poetry...'
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# reload zsh to get updated PATH
exec zsh
pipx install poetry

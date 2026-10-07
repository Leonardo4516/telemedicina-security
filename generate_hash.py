import bcrypt
password = b"Password123!"
hashed = bcrypt.hashpw(password, bcrypt.gensalt(10))
print(hashed.decode())

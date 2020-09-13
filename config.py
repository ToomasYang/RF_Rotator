import os

class Config(object):
    SECRET_KEY = os.environ.get('SECRET_KEY') or '!m2#k4^khwWtm@'

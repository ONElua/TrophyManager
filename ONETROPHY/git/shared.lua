-- Constants

APP_REPO = "ONElua"
APP_PROJECT = "TrophyManager"

APP_VERSION_MAJOR = 0x01 -- major.minor
APP_VERSION_MINOR = 0x02

APP_VERSION = ((APP_VERSION_MAJOR << 0x18) | (APP_VERSION_MINOR << 0x10)) -- Union Binary

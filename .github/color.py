# Terminal color definitions - 02/06/2025
class fg:
    BLACK       = '\033[30m'
    RED         = '\033[31m'
    GREEN       = '\033[32m'
    GREENER     = '\033[92m'
    YELLOW      = '\033[33m'
    BLUE        = '\033[34m'
    MAGENTA     = '\033[35m'
    CYAN        = '\033[36m'
    WHITE       = '\033[37m'
    HEADER      = '\033[95m'
    REPEAT      = '\033[94m'
    ALERT       = '\033[96m'
    WARNING     = '\033[93m'
    FAIL        = '\033[91m'
    BOLD        = '\033[1m'
    UNDERLINE   = '\033[4m'
    LIGHT_GRAY  = "\033[0;37m"
    DARK_GRAY   = "\033[1;30m"
    LIGHT_RED   = "\033[1;31m"
    LIGHT_GREEN = "\033[1;32m"
    LIGHT_BLUE  = "\033[1;34m"
    LIGHT_CYAN  = "\033[1;36m"
    LIGHT_WHITE = "\033[1;37m"
    RESET       = '\033[39m'
class bg:
    BLACK   = '\033[40m'
    RED     = '\033[41m'
    GREEN   = '\033[42m'
    YELLOW  = '\033[43m'
    BLUE    = '\033[44m'
    MAGENTA = '\033[45m'
    CYAN    = '\033[46m'
    WHITE   = '\033[47m'
    RESET   = '\033[49m'
class style:
    BRIGHT    = '\033[1m'
    DIM       = '\033[2m'
    NORMAL    = '\033[22m'
    END       = '\033[0m'
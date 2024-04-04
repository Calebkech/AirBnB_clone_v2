#!/usr/bin/python3
# Fabfile to generate a .tgz archive from the contents of web_static.
import os.path
from datetime import datetime
from fabric.api import local


def do_pack():
    """Create a tar gzipped archive of the directory web_static."""
    try:
        dt = datetime.utcnow()
        file = "versions/web_static_{}{}{}{}{}{}.tgz".format(dt.year,
                                                             dt.month,
                                                             dt.day,
                                                             dt.hour,
                                                             dt.minute,
                                                             dt.second)
        if os.path.isdir("versions") is False:
            local("mkdir -p versions")

        local("tar -cvzf {} web_static".format(file))
        return file
    except Exception as e:
        print("An error occurred:", str(e))
        return None


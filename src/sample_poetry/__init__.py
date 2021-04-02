from pathlib import Path

from single_source import get_version


def __get_version():
    pyproject_dir = Path(__file__).parent.parent
    version = get_version(__name__, pyproject_dir)
    if not version:
        return get_version(__name__, pyproject_dir.parent)
    return version


__version__ = __get_version()

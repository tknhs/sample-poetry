from sample_poetry import __version__, animal


def test_version():
    assert __version__ == "0.1.0"


class TestAnimal:
    def test_dog(self):
        d = animal.Dog()
        assert d.say() == "Bow Wow"

    def test_cat(self):
        c = animal.Cat()
        assert c.say() == "Meow"

    def test_mock_cat(self, mocker):
        c = animal.Cat()

        def mock_say(self):
            return "hello"

        mocker.patch("sample_poetry.animal.Cat.say", mock_say)
        assert c.say() == "hello"

"""Role testing files using testinfra."""
import allure

@allure.title("Checking python3 dependencies")
def test_python_dependencies(host):

   pydeps = ["python3", "python3-pip", "python3-venv"]
   for i in pydeps:
      with allure.step("Ensure " + i + " is installed"):
         assert host.package(i).is_installed == True 

   #  python3 = host.package("python3")
   #  pip3 = host.package("python3-pip")
   #  venv = host.package("python3-venv")


   #  with allure.step("Python3 is installed"):
   #     assert python3.is_installed
   #  with allure.step("Pip3 is installed "):
   #     assert pip3.is_installed
   #  with allure.step("Venv is installed"):
   #     assert venv.is_installed

@allure.title("Checking pip packages")
def test_pip_packages(host):

    pip_list = ["pytest", "allure-pytest", "pytest-testinfra", "cryptography", "molecule", "docker", "ansible", "ansible-core", "hvac"]
    for i in pip_list:
      with allure.step("Ensure " + i + " is installed"):
         assert host.pip_package(i, pip_path="/opt/molecule-virtualenv/bin/pip").is_installed == True 
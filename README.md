# Apex Fintech Solutions Manila Technical Assessment

This project contains the automation framework for the Apex Fintech Solutions technical assessment. This project uses [Robot Framework](https://robotframework.org/) on [Python](https://www.python.org/) using the [Browser Library](https://robotframework-browser.org/).

## Setup

1. Install [Python](https://www.python.org/downloads/).
2. Install [NodeJS](https://nodejs.org/en/download/package-manager).
3. Clone or download this repository in your local machine.
4. In your terminal, go to the project's root folder.
5. Create a Python virtual environment: `python3 -m venv env` (or just python if python3 doesn't work)
6. Activate the virtual environment
   - MacOS: `source env/bin/activate`
   - Windows: `.\env\Scripts\activate`
7. Download and install required packages: `pip install -r requirements.txt`
8. Initialize the browser library: `rfbrowser init`

## Running tests

Tests are located in **/tests**.

To execute all tests, run from the project root with `robot -d reports tests`. (This will run all .robot files in the **/tests** folder and store reports in a **/reports** folder)

To disable headless mode in running the tests, run from the project root with `robot -d reports -v HEADLESS:false tests`.

See the Robot Framework [docs](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#specifying-test-data-to-be-executed) for more run options.

## Project structure

**Directories**

This project uses the [Page Object Model](https://martinfowler.com/bliki/PageObject.html). Structure is as follows:

- **tests** - contains test suites written as .robot files
- **resources** - contains folders for test keywords, resource mappings, and the common file
  - **pageobjects** - contains python files for every page object where selectors are defined. Files are grouped by component or page, where:
    - components are web elements such as headers/footers, navigation/burger menus, modals, etc.
    - pages are full-body grouped web elements
  - **keywords** - contains robot files for user-defined keywords used in feature tests
  - **common** - robot file that serves as the centralized source of libraries, resources, and other variables for tests
- **inputs** - contains python files where input data for feature tests are defined
- **config** - contains python and/or robot files where URLs, keys, env variables, and other core test configuration/parameters are defined

## Reports

Reports will be generated after a test run has finished to completion. The following reports can be found in the **/reports** folder in the root folder of the project (if it exists), or whichever path was provided to the `-d` argument in the run command:

- **report.html**: report with high-level results information useful for non-technical stakeholders or attaching to tickets

- **log.html**: report with low-level information (and screenshots) useful for debugging automation code

- Screenshots are also saved separately from the report files as .png files

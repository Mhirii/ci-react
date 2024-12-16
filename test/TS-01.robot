*** Settings ***
Documentation       This is a Robot test suite

Library             Browser
Library             String

Suite Setup         New Browser    browser=${BROWSER}    headless=${HEADLESS}
Suite Teardown      Close Browser
# Test Setup    New Context    viewport={'width': 1920, 'height': 1080}
# Test Teardown    Close Context


*** Variables ***
${BROWSER}      chromium
${HEADLESS}     ${False}
${URL}          https://todomvc.com/examples/typescript-react/


*** Test Cases ***
Add a ToDo
    [Documentation]    Checks if ToDos can be added and ToDo count increases
    [Tags]    add todo
    Given Todo App is open
    When Add new Todo "test1"
    Then Counter should be 1 item left

Add two Todos
    [Documentation]    Checks if ToDos can be added and ToDo count increases
    [Tags]    add todo
    Given Todo App is open
    When Add new Todo "test1"
    And Add new Todo "test2"
    Then Counter should be 2 items left

Add ToDo And Mark It
    [Tags]    mark todo
    Given ToDo App is open
    When Add new ToDo "mark test"
    And Mark Todo "mark test"
    Then Counter should be 0 items left

Check If Marked ToDos are removed
    Given ToDo App is open
    And Add new Todo "todo 1"
    And Add new Todo "todo 2"
    When Mark Todo "todo 2"
    Then Counter should be 1 item left

Check if Active Filter works
    Given Todo App is open
    When Add new Todo "todo 1"
    And Add new Todo "todo 2"
    And Mark Todo "todo 2"
    And Press Active Filter
    Then Counter should be 1 item left

Check if Completed Filter works
    Given Todo App is open
    When Add new Todo "todo 1"
    And Add new Todo "todo 2"
    And Mark Todo "todo 2"
    And Press Completed Filter
    Then Counter should be 1 item left

Check if Clear Completed works
    Given Todo App is open
    When Add new Todo "todo 1"
    And Add new Todo "todo 2"
    And Mark Todo "todo 2"
    And Clear Completed
    Then Counter should be 1 item left

Add A Lot Of Todos
    Given ToDo App is open
    When Add "100" Todos
    Then Counter should be 100 items left


*** Keywords ***
Todo App is open
    New Page    ${URL}

Add new Todo "${title}"
    Fill Text    .new-todo    ${title}
    Press Keys    .new-todo    Enter

Counter should be ${count}
    Get Text    span.todo-count    ==    ${count}

Mark Todo "${title}"
    Click    "${title}" >> .. >> input.toggle

Press Active Filter
    Click    "Active"

Press Completed Filter
    Click    "Completed"

Clear Completed
    Click    "Clear completed"

Add "${count}" Todos
    ${x}=    Set Variable    ${0}
    WHILE    ${x} < ${count}
        ${x}=    Evaluate    ${x} + 1
        Add New ToDo "ToDo #${x}"
    END

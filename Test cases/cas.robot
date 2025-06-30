*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}              http://localhost/flarum-v1.x-php8.0/public/
${TIMEOUT}          20s
${MODAL_TIMEOUT}    20s

*** Keywords ***
Attendre Disparition Backdrop
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    xpath=//div[contains(@class,'ModalManager-invisibleBackdrop')]    ${MODAL_TIMEOUT}

Cliquer Sur Bouton Modal
    [Arguments]    ${xpath}
    Wait Until Element Is Visible    ${xpath}    ${TIMEOUT}
    Wait Until Element Is Enabled    ${xpath}    ${TIMEOUT}
    Attendre Disparition Backdrop
    Click Element    ${xpath}
    Sleep    1s
    Attendre Disparition Backdrop

Ouvrir La Page De Connexion
    Open Browser    ${URL}    chrome
    Maximize Browser Window
    Wait Until Element Is Visible    xpath=//button[normalize-space()='Log In']    ${TIMEOUT}
    Attendre Disparition Backdrop
    Cliquer Sur Bouton Modal    xpath=//button[normalize-space()='Log In']
    Wait Until Element Is Visible    xpath=//input[@placeholder='Username or Email']    ${TIMEOUT}
    Sleep    0.5s

Ouvrir La Page D'Inscription
    Open Browser    ${URL}    chrome
    Maximize Browser Window
    Wait Until Element Is Visible    xpath=//button[normalize-space()='Sign Up']    ${TIMEOUT}
    Attendre Disparition Backdrop
    Cliquer Sur Bouton Modal    xpath=//button[normalize-space()='Sign Up']
    Wait Until Element Is Visible    xpath=//input[@placeholder='Username']    ${TIMEOUT}
    Sleep    0.5s

Faire Login
    [Arguments]    ${username}    ${password}
    Input Text    xpath=//input[@placeholder='Username or Email']    ${username}
    Input Text    xpath=//input[@placeholder='Password']    ${password}
    Cliquer Sur Bouton Modal    xpath=//button[@type='submit' and normalize-space()='Log In']

Faire Inscription
    [Arguments]    ${username}    ${email}    ${password}
    Input Text    xpath=//input[@placeholder='Username']    ${username}
    Input Text    xpath=//input[@placeholder='Email']    ${email}
    Input Text    xpath=//input[@placeholder='Password']    ${password}
    Cliquer Sur Bouton Modal    xpath=//button[@type='submit' and normalize-space()='Sign Up']

Fermer Navigateur
    Close Browser

*** Test Cases ***

Connexion Valide
    [Documentation]    Vérifie qu'un utilisateur peut se connecter avec de bons identifiants
    Ouvrir La Page De Connexion
    Faire Login    berrichihanae1@gmail.com    CGI.@2026
    Wait Until Page Contains    Welcome to CGI FORUM    ${TIMEOUT}
    Fermer Navigateur

Connexion Invalide
    [Documentation]    Vérifie qu'un utilisateur ne peut pas se connecter avec de mauvais identifiants
    Ouvrir La Page De Connexion
    Faire Login    faux_utilisateur    mauvais_mdp
    Page Should Contain    Log In
    Fermer Navigateur

Inscription Valide
    [Documentation]    Vérifie qu'un nouvel utilisateur peut créer un compte
    Ouvrir La Page D'Inscription
    Faire Inscription    testuser    nouveau@email.com    testpassword
    Wait Until Page Contains    Welcome to CGI FORUM    ${TIMEOUT}
    Fermer Navigateur

Inscription Invalide
    [Documentation]    Vérifie que l'inscription échoue si l'email existe déjà
    Ouvrir La Page D'Inscription
    Faire Inscription    utilisateur_existant    berrichihanae1@gmail.com    motdepasse123
    Page Should Contain    Sign Up
    Fermer Navigateur
*** Settings ***
Documentation       Intelligent Document Processing using various document
...    understanding engines.

Library    Collections
Library    RPA.DocumentAI
Library    RPA.Robocorp.WorkItems


*** Variables ***
${INVOICE_PDF_FILE}    devdata${/}parallels.pdf
${INVOICE_PNG_FILE}    devdata${/}parallels.png
${INVOICE_PNG_URL}
...    https://github.com/robocorp/example-document-ai/raw/master/devdata/parallels.png

${GOOGLE_REGION}    eu


*** Keywords ***
Init Google
    Init Engine    google    vault=document_ai:serviceaccount
    ...    region=${GOOGLE_REGION}


Init Base64
    Init Engine    base64ai    vault=document_ai:base64ai


Init Nanonets
    Init Engine    nanonets    vault=document_ai:nanonets


Process Document
    &{payload} =    Get Work Item Variables
    &{fake_email} =    Create Dictionary    body    ${payload}
    &{parsed_email} =    Get Work Item Variable    email    ${fake_email}
    &{engines} =    Set Variable    ${parsed_email}[body]

    FOR    ${engine}    IN    @{engines}
        Log    Scanning with engine: ${engine}...
        ${config} =    Get From Dictionary    ${engines}    ${engine}
        &{auth} =    Get From Dictionary    ${config}    auth
        Init Engine    ${engine}    &{auth}

        &{predict} =    Get From Dictionary    ${config}    predict
        @{invoices} =    Get Work Item Files    invoice.*    dirname=${OUTPUT_DIR}
        FOR    ${invoice}    IN    @{invoices}
            Log    Processing file: ${invoice}
            Predict    ${invoice}    &{predict}
            @{data} =    Get Result
            Log List    ${data}
        END
    END


*** Tasks ***
Document AI Google
    [Documentation]    Analyze a PDF with a specific model of a pre-configured project
    ...    in a specific region and retrieve the detected fields only as a result.
    [Setup]    Init Google

    Predict    ${INVOICE_PDF_FILE}    model=df1d166771005ff4
    ...    project_id=complete-agency-347912    region=${GOOGLE_REGION}
    @{data} =    Get Result
    Log List    ${data}


Document AI Base64
    [Documentation]    Analyze a remote image with an automatically detected model and
    ...    retrieve all the extensive details as a result.
    [Setup]    Init Base64

    Predict    ${INVOICE_PNG_URL}    mock=${False}
    @{data} =    Get Result    extended=${True}
    Log List    ${data}


Document AI Nanonets
    [Documentation]    Analyze a PDF with a specialized model and retrieve the detected
    ...    fields only as a result.
    [Setup]    Init Nanonets

    Predict    ${INVOICE_PDF_FILE}    model=858e4b37-6679-4552-9481-d5497dfc0b4a
    @{data} =    Get Result
    Log List    ${data}


Document AI All
    [Documentation]    Use all the supported engines one by one to extract detected
    ...    fields in the same screenshot of the PDF file. (containing invoice data)

    # Initialize all the engines one by one. (authorization)
    Init Google
    Init Base64
    Init Nanonets

    # Now setup the models and other required data for the prediction given each engine.
    &{google_params} =    Create Dictionary
    ...    model    df1d166771005ff4
    ...    project_id    complete-agency-347912
    ...    region    ${GOOGLE_REGION}
    &{base64_params} =    Create Dictionary
    ...    model    finance/invoice
    &{nanonets_params} =    Create Dictionary
    ...    model    858e4b37-6679-4552-9481-d5497dfc0b4a
    &{engines} =    Create Dictionary
    ...    google    ${google_params}
    ...    base64ai    ${base64_params}
    ...    nanonets    ${nanonets_params}

    FOR    ${engine}    IN    @{engines}
        Switch Engine    ${engine}
        Log    Scanning with engine: ${engine}...

        &{params} =    Get From Dictionary    ${engines}    ${engine}
        Predict    ${INVOICE_PNG_FILE}    &{params}
        @{data} =    Get Result
        Log List    ${data}
    END


Document AI Work Items
    [Documentation]    Analyze documents with data and configuration from the received
    ...    input Work Items, be them created in Control Room, passed from a previous
    ...    Step or collected from a triggering e-mail.
    For Each Input Work Item    Process Document    return_results=${False}

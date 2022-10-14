*** Settings ***
Documentation       Intelligent Document Processing using various document
...    understanding engines.

Library    RPA.DocumentAI


*** Variables ***
${INVOICE_PDF_FILE}    devdata${/}parallels.pdf
${INVOICE_PNG_URL}    https://github.com/robocorp/example-document-ai/raw/master/devdata/parallels.png


*** Tasks ***
Document AI Google
    ${region} =    Set Variable    eu  # default 'us'
    Init Engine    google    vault=document_ai:serviceaccount    region=${region}
    Predict    ${INVOICE_PDF_FILE}    model=df1d166771005ff4
    ...    project_id=complete-agency-347912    region=${region}
    ${data} =    Get Result
    Log List    ${data}


Document AI Base64
    Init Engine    base64ai    vault=document_ai:base64ai
    Predict    ${INVOICE_PNG_URL}    mock=${True}

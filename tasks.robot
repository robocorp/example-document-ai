*** Settings ***
Documentation       Intelligent Document Processing using various document
...    understanding engines.

Library    RPA.DocumentAI
Library    Collections


*** Variables ***
${INVOICE_FILE}    devdata${/}parallels.pdf


*** Tasks ***
Document AI Google
    ${region} =    Set Variable    eu  # default 'us'
    Init Engine    google    vault=document_ai:serviceaccount    region=${region}
    Predict    ${INVOICE_FILE}    model=df1d166771005ff4
    ...    project_id=complete-agency-347912    region=${region}
    ${data} =    Get Result
    Log List    ${data}

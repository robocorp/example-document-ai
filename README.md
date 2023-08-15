# `RPA.DocumentAI`: Intelligent Document Processing with various engines

Currently supported engines:
- Google: `google` (requires `rpaframework-google`)
- Base64: `base64ai`
- Nanonets: `nanonets`


## Tasks

Process a real world PDF [invoice](./devdata/parallels.pdf) (or its PNG
[counterpart](./devdata/parallels.png)) with the following tasks:
- `Document AI Google`: using **Google** engine
- `Document AI Base64`: using **Base64** engine
- `Document AI Nanonets`: using **Nanonets** engine
- `Document AI All`: using all the available engines
- `Document AI Work Items`: using custom configured engines for multiple files

## Secrets

We recommend using Control Room's Vault for storing the API keys you'd normally need
to configure before being able to operate these libraries which need to authenticate
in their external services before being able to predict a document.

The expected structure can be observed within our [*vault.yaml*](./devdata/vault.yaml)
file and looks like so:

```yaml
document_ai:
  serviceaccount: {"type": "service_account", ...}
  base64ai: cosmin@robocorp.com,17**********c44
  nanonets: Zs**************OEF
```

out of which we can understand the following:
- **Google** uses a JSON (serialized dictionary) describing your
  [service account](https://cloud.google.com/iam/docs/service-account-overview) private
  key under the `serviceaccount` field.
  - [**`Init Document AI`**](https://robocorp.com/docs/libraries/rpa-framework/rpa-cloud-google/keywords#init-document-ai)
- **Base64** needs two comma-separated values under `base64ai`, which unfolds into the
  account e-mail address and an
  [API key](https://documenter.getpostman.com/view/10132588/SWT5hfdz#1-standards:~:text=1.2.%20Authentication%20%26%20authorization)
  generated under it.
  - [**`Set Authorization`**](https://robocorp.com/docs/libraries/rpa-framework/rpa-documentai-base64ai/keywords#set-authorization)
- **Nanonets** only requires a valid
  [API key](https://nanonets.com/documentation/#section/Authentication) under
  `nanonets`.
  - [**`Set Authorization`**](https://robocorp.com/docs/libraries/rpa-framework/rpa-documentai-nanonets/keywords#set-authorization)

> Use [**`Init Engine`**](https://robocorp.com/docs/libraries/rpa-framework/rpa-documentai/keywords#init-engine)
> with any of the above for a unified & simplified experience.

⚠️ At all times keep these values private (securely stored in our Vault) and treat
them like passwords.

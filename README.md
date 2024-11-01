# GitSOPS Demo

**GitSOPS Demo** is a sample project that demonstrates how to use [GitSOPS](https://github.com/ammarlakis/gitsops) GitHub Actions to manage secrets securely within Git repositories. This project includes workflows for **reading**, **upserting**, and **deleting** secrets in encrypted dotenv files using SOPS, enabling secure secrets management directly in CI/CD pipelines while adhering to the GitOps principle of treating the Git repository as the single source of truth.

## Overview

The GitSOPS Demo project illustrates:
- Securely **adding or updating** secrets in environment-specific dotenv files.
- **Deleting** secrets from encrypted dotenv files.
- **Reading** secrets and using them within the pipeline.

Each workflow uses **GitSOPS** actions to encrypt, decrypt, and manage secrets with SOPS, committing changes back to the repository to maintain Git as the source of truth.

This project can serve as an endpoint within an internal developer platform, where GitHub acts as the storage backend, and GitHub Actions serve as the platform's API. In this demo, we interact with GitHub Actions through the GitHub web interface; however, in an optimal setup, an internal developer portal would be used to interact with these actions.

## Prerequisites

- **AWS Credentials**: Set up in GitHub Secrets if using AWS KMS for encryption and decryption.
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_DEFAULT_REGION`

## Workflows

### 1. Upsert Secret

This workflow adds or updates a secret in a dotenv file for a specified environment.

#### Usage
Trigger the **Upsert Secret** workflow manually via GitHub Actions, providing the required inputs:
- **secret_name**: The name of the secret to add or update.
- **secret_value**: The value of the secret.
- **environment**: The target environment (`development` or `production`).

#### Workflow Example

```yaml
name: Upsert Secret

on:
  workflow_dispatch:
    inputs:
      secret_name:
        description: The name of the secret to add or update
        required: true
      secret_value:
        description: The value of the secret
        required: true
      environment:
        description: The environment to update its secrets
        type: choice
        options:
          - development
          - production
```

This workflow:
- Checks out the repository.
- Uses the `ammarlakis/gitsops` upsert action to add or update the secret.
- Commits and pushes the change back to the repository.

### 2. Delete Secret

This workflow removes a specified secret from the encrypted dotenv file for a given environment.

#### Usage
Trigger the **Delete Secret** workflow manually with:
- **secret_name**: The name of the secret to delete.
- **environment**: The target environment (`development` or `production`).

#### Workflow Example

```yaml
name: Delete Secret

on:
  workflow_dispatch:
    inputs:
      secret_name:
        description: The name of the secret to delete
        required: true
      environment:
        description: The environment to delete the secret from
        type: choice
        options:
          - development
          - production
```

This workflow:
- Checks out the repository.
- Uses the `ammarlakis/gitsops` delete action to remove the secret.
- Commits and pushes the change back to the repository.

### 3. Read Secrets and Deploy

This workflow reads secrets from the encrypted dotenv file, exports them as environment variables, and runs a deployment script.

#### Usage
Trigger the **Read Secrets and Deploy** workflow manually with:
- **environment**: The target environment (`development` or `production`).

#### Workflow Example

```yaml
name: Read Secrets and Deploy

on:
  workflow_dispatch:
    inputs:
      environment:
        description: The environment to read secrets from
        type: choice
        options:
          - development
          - production
```

This workflow:
- Checks out the repository.
- Uses the `ammarlakis/gitsops` read action to export secrets as environment variables.
- Executes `myproject/deploy.sh` to deploy the application using the exported secrets. The deployment script can contain a Terraform command or other tooling where secrets are used as configuration values.

## Secrets Management with SOPS

GitSOPS Demo uses [SOPS](https://github.com/mozilla/sops) for encrypting secrets, providing secure storage within Git. Each environment (`development` or `production`) has a dedicated encrypted dotenv file in `myproject`:
- `myproject/development-secrets.env`
- `myproject/production-secrets.env`

These files are encrypted using SOPS and managed within Git, leveraging KMS keys to ensure security. GitSOPS actions handle decryption automatically, allowing workflows to read, update, or delete secrets as needed.

## License

This project is licensed under the MIT License.

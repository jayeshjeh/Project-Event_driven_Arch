# Event-Driven Architecture with AWS Lambda and SQS

This project demonstrates an event-driven architecture using **AWS Lambda**, **Amazon SQS**, and **AWS CloudWatch** for building a simple event-based processing system. The infrastructure is managed using **Terraform**, and the deployment pipeline is set up using **GitHub Actions** for CI/CD.

---

## Project Overview

The project contains:

- **AWS Lambda Function**: A Python-based Lambda function that processes messages from an SQS queue and logs details to CloudWatch.
- **SQS Queue**: An SQS queue that triggers the Lambda function on receiving messages.
- **Terraform Configuration**: Terraform scripts to deploy the Lambda function, SQS queue, and related IAM roles and policies.
- **CI/CD Pipeline**: GitHub Actions pipeline to automatically deploy infrastructure and Lambda code changes.

---

## Architecture

1. **SQS Queue**: 
    - The SQS queue receives event messages such as "build_succeeded".
    - The queue triggers the Lambda function when a new message is pushed.

2. **Lambda Function**: 
    - The Lambda function processes the messages from SQS, logs the message details to CloudWatch, and performs any additional processing (e.g., triggering other services).
    - The function is triggered every time a new message is added to the queue.

3. **CloudWatch Logs**: 
    - The Lambda function logs detailed information about the received message in CloudWatch for monitoring and debugging.

4. **CI/CD Pipeline**:
    - GitHub Actions is used for Continuous Integration and Continuous Deployment. It triggers on commits to the `main` branch or when changes are made to infrastructure files (`modules`, `environments`, `lambda_src`).
    - Terraform manages infrastructure deployment, and Lambda updates are automatically deployed via GitHub Actions.

---

## Prerequisites

To get started with this project, make sure you have the following installed:

- **Terraform** (v1.5.5 or later)
- **AWS CLI** (configured with the necessary permissions)
- **GitHub** (to push and manage code)
- **Node.js** (for running the Lambda function locally, if needed)

---

## Setup

### 1. Clone the Repository

First, clone the repository to your local machine:

```bash
git clone https://github.com/jayeshjeh/Project-Event_driven_Arch.git
cd Project-Event_driven_Arch
```

### 2. Terraform Configuration

Navigate to the appropriate environment folder (e.g., `environments/dev`), and initialize Terraform:

```bash
cd environments/dev
terraform init
```

### 3. Configure AWS Credentials

You will need AWS credentials with sufficient permissions to manage the Lambda function, SQS, and IAM roles/policies.

If you are using GitHub Actions, configure AWS OIDC (OpenID Connect) for authentication. You can store the role ARN in GitHub secrets:

- **AWS OIDC Role**: Create an IAM role in AWS for GitHub Actions using OIDC authentication.
- **GitHub Secrets**: Add `AWS_OIDC_ROLE_ARN` to your GitHub repository secrets with the ARN of the role.

### 4. Deploy Infrastructure Using Terraform

To deploy the infrastructure (SQS queue, Lambda function, IAM roles), run:

```bash
terraform plan -var-file=terraform.tfvars
terraform apply -auto-approve -var-file=terraform.tfvars
```

This will deploy the resources and the Lambda function.

### 5. Configure GitHub Actions CI/CD

The GitHub Actions pipeline is configured to automatically deploy updates when you push code changes to the repository.

In the `.github/workflows` directory, the `terraform.yml` file defines the CI/CD pipeline:

- **Checkout code**
- **Setup Terraform**
- **Configure AWS credentials**
- **Run Terraform commands** (e.g., `fmt`, `init`, `validate`, `plan`, `apply`)

---

## Testing Lambda

You can manually test the Lambda function by sending a message to the SQS queue:

```bash
aws sqs send-message --queue-url <SQS_QUEUE_URL> --message-body '{"type":"build_succeeded","build_id":123}'
```

To view the logs for the Lambda function, use:

```bash
aws logs tail /aws/lambda/ci-event-processor --since 5m --follow
```

---

## Monitor CI/CD Pipeline

After pushing changes to the main branch or opening a pull request, GitHub Actions will automatically trigger the pipeline. You can view the pipeline logs in GitHub under the "Actions" tab.

---

## Manual Testing via Console

- **Lambda Function**: You can test the Lambda function directly in the AWS Lambda console by sending sample event data.
- **SQS Queue**: Messages can be sent to the SQS queue using the AWS CLI or via the AWS Console.

---

## Folder Structure

```
Project-Event_driven_Arch/
├── environments
│   ├── dev
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   └── prod
│       ├── main.tf
│       ├── terraform.tfvars
│       └── variables.tf
├── lambda_src
│   ├── index.py
│   └── lambda.zip
├── modules
│   ├── event_mapping
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── iam
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── lambda
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── sg
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── sqs
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
└── README.md

12 directories, 28 files

```

---

## Troubleshooting

### Common Issues:

- **No CloudWatch logs**: Ensure the Lambda function has the necessary IAM permissions to create and write to CloudWatch Logs.
- **Lambda not triggered**: Verify the SQS queue and Lambda trigger are correctly configured. Ensure the Lambda function is subscribed to the SQS queue.
- **Terraform apply issues**: Ensure that Terraform is configured with the correct AWS credentials, and that you are running it in the correct region.

### Logs:

- **Lambda logs**: Access them in the CloudWatch console or via AWS CLI:

    ```bash
    aws logs tail /aws/lambda/ci-event-processor
    ```

- **GitHub Actions pipeline logs**: Available in the "Actions" tab in your GitHub repository.

---

## Contributing

Feel free to fork the repository, make changes, and submit pull requests. Please ensure all changes are well-documented and have corresponding tests.

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.

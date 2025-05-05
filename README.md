# Event-Driven Architecture with AWS Lambda and SQS

This project demonstrates an event-driven architecture using **AWS Lambda**, **Amazon SQS**, and **AWS CloudWatch** for building a simple event-based processing system. The infrastructure is managed using **Terraform**, and the deployment pipeli## Project Overview

The project contains:

- **AWS Lambda Function**: A Python-based Lambda function that processes messages from an SQS queue and logs details to CloudWatch.
- **SQS Queue**: An SQS queue that triggers the Lambda function on receiving messages.
- **Terraform Configuration**: Terraform scripts to deploy the Lambda function, SQS queue, and related IAM roles and policies.
- **CI/CD Pipeline**: GitHub Actions pipeline to automatically deploy infrastructure and Lambda code changes.

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

## Prerequisitesne is set up using **GitHub Actions** for CI/CD.

## Project Overview

The project contains:

* **AWS Lambda Function**: A Python-based Lambda function that processes messages from an SQS queue and logs details to CloudWatch.
* **SQS Queue**: An SQS queue that triggers the Lambda function on receiving messages.
* **Terraform Configuration**: Terraform scripts to deploy the Lambda function, SQS queue, and related IAM roles and policies.
* **CI/CD Pipeline**: GitHub Actions pipeline to automatically deploy infrastructure and Lambda code changes.

## Architecture

1.  **SQS Queue**:
    * The SQS queue receives event messages such as "build_succeeded".
    * The queue triggers the Lambda function when a new message is pushed.

2.  **Lambda Function**:
    * The Lambda function processes the messages from SQS, logs the message details to CloudWatch, and performs any additional processing (e.g., triggering other services).
    * The function is triggered every time a new message is added to the queue.

3.  **CloudWatch Logs**:
    * The Lambda function logs detailed information about the received message in CloudWatch for monitoring and debugging.

4.  **CI/CD Pipeline**:
    * GitHub Actions is used for Continuous Integration and Continuous Deployment. It triggers on commits to the `main` branch or when changes are made to infrastructure files (`modules`, `environments`, `lambda_src`).
    * Terraform manages infrastructure deployment, and Lambda updates are automatically deployed via GitHub Actions.

## Prerequisites

To get started with this project, make sure you have the following installed:

* **Terraform** (v1.5.5 or later)
* **AWS CLI** (configured with the necessary permissions)
* **GitHub** (to push and manage code)
* **Node.js** (for running the Lambda function locally, if needed)

## Setup

### 1. Clone the Repository

First, clone the repository to your local machine:

```bash
git clone https://github.com/<your-username>/Project-Event_driven_Arch.git
cd Project-Event_driven_Arch

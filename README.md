## Overview
The AWS Cloud Resume Challenge is a project designed to showcase cloud skills by building an online resume hosted on AWS. This README provides an overview of the architecture and components used in the challenge.

## Architecture

![AWS Cloud Resume Challenge Architecture](https://github.com/ilovefriedrice/aws-cloud-resume-kl/assets/80792261/d762a611-e56c-4716-89be-87cc8dcb068f)

### Frontend
- **Static Website**: Hosted on AWS S3, this is a static HTML/CSS/JS website. S3 is used for its high availability and scalability.
- **Content Delivery Network (CDN)**: AWS CloudFront is used to deliver the website content globally. CloudFront speeds up the distribution of static and dynamic web content.

### Backend
- **API**: An AWS Lambda function is directly exposed through Lambda Function URLs to handle backend processes, such as retrieving or updating the visitor count. This approach simplifies the infrastructure by directly invoking the Lambda function via HTTP requests.
- **Database**: Amazon DynamoDB is utilized for storing data, such as the number of visitors to the resume site.

### CI/CD Pipeline
- **Source Control**: GitHub is used for version control and as the source repository for the codebase.
- **Automated Deployment**: Terraform is utilized for infrastructure as code (IaC) to automate the deployment workflow. This ensures that updates to the codebase in the GitHub repository trigger the necessary changes to the infrastructure, maintaining a continuous integration and continuous deployment (CI/CD) practice.

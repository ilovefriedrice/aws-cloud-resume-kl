# AWS Cloud Resume Challenge

## Overview
The AWS Cloud Resume Challenge is a project designed to showcase cloud skills by building an online resume hosted on AWS. This README provides an overview of the architecture and components used in the challenge.

## Architecture

### Frontend
- **Static Website**: Hosted on AWS S3, this is a static HTML/CSS/JS website. S3 is used for its high availability and scalability.
- **Content Delivery Network (CDN)**: AWS CloudFront is used to deliver the website content globally. CloudFront speeds up the distribution of static and dynamic web content.

### Backend
- **API**: An AWS Lambda function, triggered via AWS API Gateway, is used to handle backend processes like retrieving or updating the visitor count.
- **Database**: Amazon DynamoDB is utilized for storing data, such as the number of visitors to the resume site.

### CI/CD Pipeline
- **Source Control**: GitHub is used for version control and as the source repository for the codebase.
- **Automated Deployment**: AWS CodePipeline is configured for continuous integration and continuous deployment (CI/CD). It automates the deployment process every time the GitHub repository is updated.

### Monitoring
- **Logging and Monitoring**: Amazon CloudWatch is used for monitoring the performance of AWS services and for logging the operation of the website and backend services.

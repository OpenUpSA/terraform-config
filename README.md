# OpenUp Terraform config

## Gov ZA Scraper

This will create

- The `gov-za-scraper` s3 bucket
- The `gov-za-scraper` iam user
- The bucket acl
- An access key ID and secret for the user
- A policy allowing the user to do everything with the bucket and list all buckets
- Tag everything with a project slug

Steps:

1. cd into gov_za_scraper
2. Run `terraform init`
3. If you have configured AWS CLI with a profile named `openup`, you can run

    AWS_PROFILE=openup terraform plan

   and so on to plan and apply changes to the AWS resources for this project in
   the OpenUp AWS account.

# TODO:

- shared state
  - how should we share state within the team? State must be shared because terraform uses it to decide which resources in a configuration exist, and which are yet to be created.
    - Perhaps the s3 backend, since we already need s3 credentials to manage s3 resources
    - Watch out: secrets like an AWS IAM user access key secret is included in state. We can't just commit state to git or something.
- Configuration structure
  - How should we structure the config for the many projects we have at OpenUp?
    - This `cd` into the project directory approach doesn't seem great. It means there's a state file for each project and the terraform resource names are things like `aws_s3_bucket.bucket`. Each folder needs to be `init`d and so on. Should they all be modules included by a top level configuration?
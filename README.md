# Terraform Template

Work In Progress

## First Time

- Log into Terraform Cloud


## Set Up New Workspace/Repo

- Create New Repo: https://github.com/davaoio/terraform-template/generate
- Update `main.tf` backend section with `organization` and `workspace`
- Run `terraform init` to create the workspace in TFC
- Create AWS Access Credentials (manually?)
- Create TFC Environment Variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
- `AWS_SECRET_ACCESS_KEY` should be marked as sensitive
- `AWS_ACCESS_KEY_ID` should not be sensitive, so you can know which key is being used
- Connect TFC with GitHub
- Might need to give the TF account explicit access to the repo first.
- In `vpc.tf`, replace `EXAMPLE` with your workspace name
- In `route53.tf`, replace `example` with your workspace name
- In `sg.tf`, replace `EXAMPLE` with your workspace name
- Run `terraform fmt` to make sure all files are formatted correctly
- Run `terraform plan` to verify everything works.
- Planning runs in TFC, so your local machine doesn't need to be configured for AWS
- If plan works fine, commit and push to master. TFC will take it from there.
- In TFC, review the plan and confirm

For install that project we need:

1) Configure awscli or use `export` env's (environments are example)
        
```     
    export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
    export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    export AWS_DEFAULT_REGION=us-west-2 
```        
2) input variable iam_user_name in `./variable.tf`
3) `terraform init`
4) `terraform plan`
5) `terraform apply`

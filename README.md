In this project we used a socks-shop (https://github.com/microservices-demo/microservices-demo) that contains the following components:
1) frontend
2) backend
3) database

Deployment is provisioned out with the help of Terraform with the creation of the EKS cluster with cluster-autoscaling, alb ingress controller and the deployment of the helm chart with other components
For install that project we need:
1) Configure awscli or use `export` env's (environments are example)
        
```     
    export AWS_ACCESS_KEY_ID=PUTHEREYOURKEY
    export AWS_SECRET_ACCESS_KEY=PUTHEREYOURsecretKEY
    export AWS_DEFAULT_REGION=us-east-1 
```        
2) input variable iam_user_name in `./variable.tf`
3) `terraform init`
4) `terraform plan`
5) `terraform apply`
6) `aws eks --region us-east-1 update-kubeconfig --name test-infra-eks-cluster`
7) `kubectl get ingress -A | grep chart-socks | awk '{print $5}'`
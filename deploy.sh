#!/bin/sh
kubectl apply -f namespace.yml
kubectl apply -f secret.yml
kubectl apply -f deployment.yml
kubectl apply -f service.yml

#aws eks update-kubeconfig --region us-east-1 --name tkcicd-eks-01
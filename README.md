# 使用Terraform建立VPC與EC2 instance
## 架構圖
![image](/blob/架構圖.jpg)

## 使用
複製secret.tfvars.example為secret.tfvars，然後填上SSH public key

建立infrastructure
```
terraform apply -var-file="secret.tfvars"
```

## 測試
1. 從本地連到app_server
```
ssh -i ~/.ssh/terraform ubuntu@{app-server IPv4}
```

2. 從app_server連接到db_server
```
telnet {test-server IP} 22
```

3. 修改ssh config，然後用nat instance當作堡壘機，從本地連到db_server
```
Host nat-instance
Hostname {nat的IP}
User ec2-user
Port 22
identityfile {path to private key}

Host test-server
Hostname {test-server的IP}
User ubuntu
Port 22
ProxyCommand ssh -q -W %h:%p nat-instance
identityfile {path to private key}
```

SSH進入test server
```
ssh test-server
```

4. test server能否連至外網
```
curl https://www.google.com
```

5. 檢查S3 bucket的terraform.tfstate

## 銷毀資源
```
terraform destroy -var-file="secret.tfvars" 
```

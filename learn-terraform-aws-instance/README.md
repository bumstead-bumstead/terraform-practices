# Terraform aws get started

### 기본 작업

1. EC2, S3 관리할 수 있는 IAM 생성, access key 등록
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/2ff4c840-4dc9-47b4-b347-6cc45ab05be5/Untitled.png)
    
2. choco로 install terraform 
3. access key, secrete key를 aws config로 설정

### [main.tf](http://main.tf) file 구성 확인하기

```json
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

//resource {resource type} {resource name} 의 형태
resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
```

1. **terraform block**
    
    이 프로젝트에서 **사용할 required_providers를 포함해서, 기본적인 terraform 프로젝트 설정**을 명시하는 부분이다. requried_providers는 사용하는 resource들을 공급할 주체를 설정하며, 이름을 설정한 내부 블록에서는 source, version 등을 지정할 수 있다. → required_providers는 기본적으로 terraform registry에서 가져온다.
    
2. **provider block**
    
    **지정된 provider를 구성한다.** 이 예시에서는 위에서 설정한 aws를 포함시켰지만, 여러 개의 provider를 지정할 수도 있다.
    
3. **resource block**
    
    프로젝트의 **인프라 구조를 구성할 컴포넌트를 정의한다**. resource type은, prefix로 provider의 이름이다. type과 name을 합쳐서 자원의 ID가 구성되는데, 위 예시에서는 aws_instance.app_server가 된다.
    
    그리고 블록 내부는, 사용한 provider의 규칙에 따라서 arguments를 지정한다. terraform registry의 provider마다 [이와 관련된 docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)를 제공한다.
    

### terraform instructions

1. **$ terraform init**
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/07858aa1-d1b5-4db9-8bca-c113aab7468b/Untitled.png)
    
    main.tf로 IaC를 모두 작성한 이후에, 이를 초기화하는 명령어다. 지정한 provider plugins를 모두 설치하고, 버전을 관리할 수 있는 파일을 만들어준다.
    
2. **$ terraform fmt** : 프로젝트의 terraform 코드들의 형식을 지정된 스타일로 통일해준다.
3. **$ terraform validate** : 코드들이 문법적으로 유효한 지 확인한다. 
4. **$ terraform apply** 
    
    코드로 작성한 자원들을 모두 적용한다.
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/05d320cb-be24-4e03-b200-0fb5595a7808/Untitled.png)
    
    git diff 명령어와 같이, 적용되었을 때 resource 별로 속성 값의 상태를 모두 보여준다. (known after apply)는 해당 값을 알 수 없음을 의미한다. 우리의 예시에서는, arn이나 cpu와 같은 속성들은 aws를 통해 ec2가 생성되고 나서 알 수 있게 될 것이다.
    
    이어서 yes를 입력하면, 변경 사항이 적용된다.
    
    ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/da327d01-08ae-4c2a-a1c7-29d3ae42ead4/Untitled.png)
    
5. **$ terraform show**
    
    앞서 known after apply였던 속성들을 포함한, configuration의 메타데이터를 확인할 수 있다. configuration이 적용되고 나면, terraformm.tfstate라는 파일에 정보들이 저장된다. 보안에 취약한 정보들이 있을 수 있기 때문에 깃허브에 올리지 않도록 해야한다.
    
6. **$ terraform state list** : 생성한 자원들을 나열한다.
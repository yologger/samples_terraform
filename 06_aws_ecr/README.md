# AWS EKS by Terraform
Terraform으로 AWS EKS를 구성하는 예제입니다.

## VPC 아키텍처
AWS EKS 구성을 위한 VPC 아키텍처는 다음과 같다.

![](./images/1.png)

- `VPC`
- `Public Subnet`
    - 외부 인터넷에 노출되는 서비스가 위치한다.
    - 두 개 이상의 서로 다른 AZ에 서브넷이 위치해야한다.
- `Private Subnet` 
    - 외부 인터넷으로부터 차단되는 서비스가 위치한다.
    - 보통 실제 서비스를 제공하는 WAS가 위치한다.
    - 두 개 이상의 서로 다른 AZ에 서브넷이 위치해야한다.
- `Internet Gateway`
    - Public Subnet과 외부 인터넷이 통신할 때 사용한다.
- `NAT Gateway`
    - Private Subnet에서 외부 인터넷과 아웃바운드 방향으로 통신할 때 사용한다.
- Public Subnet을 위한 `Routing Table`. 다음 두 가지 규칙을 함께 정의해야한다.
    - Public Subnet 간 통신을 위한 규칙
    - Public Subnet에서 외부 인터넷 망과 통신하기 위한 규칙
- Private Subnet을 위한 `Routing Table`. 다음 두 가지 규칙을 함께 정의해야한다.
    - Private Subnet 간 통신을 위한 규칙
    - Private Subnet에서 외부 인터넷 망으로 아웃바운드 통신을 위한 규칙을 함께 정의

## Kubernetes 아키텍처
- Control Plane은 Managed Service인 AWS EKS를 사용한다.
- ~WorkerNode는 NodeGroup(EC2)를 사용한다.~
- WorkerNode는 AWS Fargete를 사용한다.
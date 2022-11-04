# AWS EKS by Terraform
Terraform으로 AWS EKS를 구성하는 예제입니다.

## VPC 구조
AWS EKS 구성을 위한 VPC 구조는 다음과 같다.

![](./images/1.png)

- VPC
- 두 개 이상의 Public Subnet: 외부 인터넷에 노출되는 서비스가 위치한다.
- 두 개 이상의 Private Subnet: 외부 인터넷으로부터 차단되며, 실제 서비스가 위치한다.
- Internet Gateway: Public Subnet에서 외부 인터넷과 통신할 때 사용한다.
- NAT Gateway: Private Subnet에서 아웃 바운드 방향의 외부 인터넷 통신이 필요할 때 사용한다.
- Public Subnet에 연결할 Routing Table. 두 가지 규칙을 함께 정의해야한다.
    - Public Subnet 간 통신을 위한 규칙
    - Public Subnet에서 외부 인터넷 망과 통신하기 위한 규칙
- Private Subnet에 연결할 Routing Table. 두 가지 규칙을 함께 정의해야한다.
    - Private Subnet 간 통신을 위한 규칙
    - Private Subnet에서 외부 인터넷 망으로 아웃바운드 통신을 위한 규칙을 함께 정의
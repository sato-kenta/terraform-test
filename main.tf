# Providerの設定
# AWS Providerを使用してAWSのAPIを有効化し、
# ap-northeast-1(東京)リージョンへプロビジョニングを実行する

provider "aws" {
    region = "ap-northeast-1"
}

# 変数の宣言
# 複数回使用する値や、ステージング・本番のように環境によって値が変わるのものを変数で宣言する
variable "name" {
    description = "各種リソースの命名"
    default     = "terraform-aws-handson"
}

######################
# VPC
######################
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "${var.name}"
    }
}

######################
# Public Subnet
######################
# Internet Gateway
resource "aws_internet_gateway" "this" {
    vpc_id = "${aws_vpc.main.id}" # 上記の`resource "aws_vpc" "main"`が作成したVPCのIDを取得する

    tags = {
        Name = "${var.name}_public"
    }
}

# Route table
resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.main.id}"

    tags = {
        Name = "${var.name}_public"
    }
}

resource "aws_route" "public_internet_gateway" {
    route_table_id         = "${aws_route_table.public.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "${aws_internet_gateway.this.id}"
}

# Public Subnet
resource "aws_subnet" "public_1a" {
    vpc_id = "${aws_vpc.main.id}"

    cidr_block        = "10.0.0.0/24"
    availability_zone = "ap-northeast-1a"

    tags = {
        Name = "${var.name}_public_1a"
    }
}

resource "aws_route_table_association" "public_1a" {
    subnet_id      = "${aws_subnet.public_1a.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "public_1c" {
    vpc_id       = "${aws_vpc.main.id}"

    cidr_block        = "10.0.1.0/24"
    availability_zone = "ap-northeast-1c"

    tags = {
        Name = "${var.name}_public_1c"
    }
}

resource "aws_route_table_association" "public_1c" {
    subnet_id      = "${aws_subnet.public_1c.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "public_1d" {
    vpc_id = "${aws_vpc.main.id}"

    cidr_block        = "10.0.2.0/24"
    availability_zone = "ap-northeast-1d"

    tags = {
        Name = "${var.name}_public_1d"
    }
}

resource "aws_route_table_association" "public_1d" {
    subnet_id      = "${aws_subnet.public_1d.id}"
    route_table_id = "${aws_route_table.public.id}"
}

########################
# Private Subnet
########################
# Route table
resource "aws_route_table" "private_1a" {
    vpc_id = "${aws_vpc.main.id}"

    tags = {
        Name = "${var.name}"
    }
}

resource "aws_route_table" "private_1c" {
    vpc_id = "${aws_vpc.main.id}"

    tags = {
        Name = "${var.name}"
    }
}

resource "aws_route_table" "private_1d" {
    vpc_id = "${aws_vpc.main.id}"

    tags = {
        Name = "${var.name}"
    }
}

# NAT Gateway
resource "aws_eip" "nat_1a" {
    domain = "vpc"
    
    tags = {
        Name = "${var.name}_1a"
    }
}

resource "aws_eip" "nat_1c" {
    domain = "vpc"
    
    tags = {
        Name = "${var.name}_1c"
    }
}

resource "aws_eip" "nat_1d" {
    domain = "vpc"
    
    tags = {
        Name = "${var.name}_1d"
    }
}

resource "aws_nat_gateway" "nat_1a" {
    allocation_id = "${aws_eip.nat_1a.id}"
    subnet_id     = "${aws_subnet.public_1a.id}"

    tags = {
        Name = "${var.name}_1a"
    }
}

resource "aws_route" "private_natgw_1a" {
    route_table_id         = "${aws_route_table.private_1a.id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = "${aws_nat_gateway.nat_1a.id}"
}

resource "aws_nat_gateway" "nat_1c" {
    allocation_id = "${aws_eip.nat_1c.id}"
    subnet_id     = "${aws_subnet.public_1c.id}"

    tags = {
        Name = "${var.name}_1c"
    }
}

resource "aws_route" "private_natgw_1c" {
    route_table_id         = "${aws_route_table.private_1c.id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = "${aws_nat_gateway.nat_1c.id}"
}

resource "aws_nat_gateway" "nat_1d" {
    allocation_id = "${aws_eip.nat_1d.id}"
    subnet_id     = "${aws_subnet.public_1d.id}"

    tags = {
        Name = "${var.name}_1d"
    }
}

resource "aws_route" "private_natgw_1d" {
    route_table_id         = "${aws_route_table.private_1d.id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = "${aws_nat_gateway.nat_1d.id}"
}

# Private Subnet
resource "aws_subnet" "private_1a" {
    vpc_id = "${aws_vpc.main.id}"

    cidr_block        = "10.0.10.0/24"
    availability_zone = "ap-northeast-1a"

    tags = {
        Name = "${var.name}_private_1a"
    } 
}

resource "aws_route_table_association" "private_1a" {
    subnet_id      = "${aws_subnet.private_1a.id}"
    route_table_id = "${aws_route_table.private_1a.id}"
}

resource "aws_subnet" "private_1c" {
    vpc_id = "${aws_vpc.main.id}"

    cidr_block        = "10.0.11.0/24"
    availability_zone = "ap-northeast-1c"

    tags = {
        Name = "${var.name}_private_1c"
    } 
}

resource "aws_route_table_association" "private_1c" {
    subnet_id      = "${aws_subnet.private_1c.id}"
    route_table_id = "${aws_route_table.private_1c.id}"
}

resource "aws_subnet" "private_1d" {
    vpc_id = "${aws_vpc.main.id}"

    cidr_block        = "10.0.12.0/24"
    availability_zone = "ap-northeast-1d"

    tags = {
        Name = "${var.name}_private_1d"
    } 
}

resource "aws_route_table_association" "private_1d" {
    subnet_id      = "${aws_subnet.private_1d.id}"
    route_table_id = "${aws_route_table.private_1d.id}"
}
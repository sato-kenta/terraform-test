# Providerの設定
# AWS Providerを使用してAWSのAPIを有効化し、
# ap-northeast-1(東京)リージョンへプロビジョニングを実行する

provider "aws" {
    region = "ap-northeast-1"
}

# 変数の宣言
# 複数回使用する値や、ステージング・本番のように環境によって値が変わるのものを変数で宣言する

######################
# VPC
######################
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "${var.name}-vpc"
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
resource "aws_subnet" "public_sbn" {
    count                   = var.subnet_cnt
    vpc_id                  = aws_vpc.main.id
    cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
    availability_zone       = var.az_list[count.index%3]
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.name}-${var.env}-public-sbn-${count.index}"
    }
}

resource "aws_route_table_association" "public_rta" {
    count          = var.subnet_cnt
    subnet_id      = aws_subnet.public_sbn[count.index].id
    route_table_id = aws_route_table.public.id
}

########################
# Private Subnet
########################
# Route table
resource "aws_route_table" "private" {
    count = var.subnet_cnt

    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.name}-private-${var.az_list2[count.index]}"
    }
}

# NAT Gateway
resource "aws_eip" "nat" {
    count = var.subnet_cnt
    domain = "vpc"

    tags = {
        Name = "${var.name}-nat-eip-${var.az_list2[count.index]}"
    }
}

resource "aws_nat_gateway" "nat" {
    count = var.subnet_cnt

    allocation_id = aws_eip.nat[count.index].id
    subnet_id     = aws_subnet.public_sbn[count.index].id
    tags = {
        Name = "${var.name}_nat_${var.az_list2[count.index]}"
    }
}

resource "aws_route" "private_natgw" {
    count = var.subnet_cnt

    route_table_id = aws_route_table.private[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
}

# Private Subnet
resource "aws_subnet" "private_sbn" {
    count                   = var.subnet_cnt
    vpc_id                  = aws_vpc.main.id
    cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 10 + count.index)
    availability_zone       = var.az_list[count.index%3]
    tags = {
        Name = "${var.name}-${var.env}-private-sbn-${count.index}"
    }
}

resource "aws_route_table_association" "private" {
    count = var.subnet_cnt

    subnet_id      = "${aws_subnet.private_sbn[count.index].id}"
    route_table_id = "${aws_route_table.private[count.index].id}"
}
resource "aws_eks_cluster" "eksdemo" {
  name     = "ansible"
  role_arn = aws_iam_role.ansible-role.arn

  vpc_config {
    subnet_ids = ["subnet-03aacbed8fdf11c42", "subnet-042a0dae2ee2d68dc", "subnet-0c777d4fb163ba2c0"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.ansible-role-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.ansible-role-AmazonEKSVPCResourceController,
  ]
}


resource "aws_iam_role" "ansible-role" {
  name = "eks-cluster-role1"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "ansible-role-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.ansible-role.name
}

resource "aws_iam_role_policy_attachment" "ansible-role-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.ansible-role.name
}

data "tls_certificate" "ekstls" {
  url = aws_eks_cluster.eksdemo.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eksopidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.ekstls.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eksdemo.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "eksdoc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eksopidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eksopidc.arn]
      type        = "Federated"
    }
  }
}

resource "aws_eks_node_group" "Ansible_node" {
  cluster_name    = "ansible"
  node_group_name = "cluster-nodes"
  node_role_arn   = aws_iam_role.Ansible_node.arn
  subnet_ids      = ["subnet-03aacbed8fdf11c42", "subnet-042a0dae2ee2d68dc", "subnet-0c777d4fb163ba2c0"]
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  update_config {
    max_unavailable = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.Ansible-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.Ansible-node-AmazonEKS_CNI_Policy,
    # aws_iam_role_policy_attachment.Ansible-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}



resource "aws_iam_role" "Ansible_node" {
  name = "Ansible_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "Ansible-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.Ansible_node.name
}

resource "aws_iam_role_policy_attachment" "Ansible-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.Ansible_node.name
}

# resource "aws_iam_role_policy_attachment" "Ansible-node-AmazonEC2ContainerRegistryReadOnly" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#  role       = aws_iam_role.Ansible_node.name
# }
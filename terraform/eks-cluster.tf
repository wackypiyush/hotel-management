resource "aws_eks_cluster" "hotel_eks" {
  name     = "hotel-eks"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.public_subnet.id,
      aws_subnet.public_subnet_b.id
    ]
  }


  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKS_VPC_ResourceController
  ]
}

resource "aws_eks_node_group" "hotel_ng" {
  cluster_name    = aws_eks_cluster.hotel_eks.name
  node_group_name = "hotel-nodes"
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids = [
    aws_subnet.public_subnet.id,
    aws_subnet.public_subnet_b.id
  ]


  scaling_config {
    desired_size = 2 # Updated
    max_size     = 2 # Updated
    min_size     = 1 # Updated (keep 1 or set to 2)
  }

  instance_types = ["t3.small"]

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]
}

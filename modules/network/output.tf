output "vpc_id" {
  value = aws_vpc.main.id
}

output "pri_a_2_id" {
  value = aws_subnet.pri_a_2.id
}

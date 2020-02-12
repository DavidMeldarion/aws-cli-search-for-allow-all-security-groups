#Step One: describe-security-groups and filter by CidrIP=0.0.0.0/0
aws ec2 describe-security-groups --profile="Example" --region=us-east-1 --filter "Name=ip-permission.cidr,Values=0.0.0.0/0" --query "SecurityGroups[*].{ID:GroupId}"
#Output= list of security group names and IDs that have a CidrIP of 0.0.0.0/0

#Step Two: Search for any resource associated with Security Groups that have a CidrIP of 0.0.0.0/0:
for i in `aws ec2 describe-security-groups --profile="Example" --region=us-east-1 --filter "Name=ip-permission.cidr,Values=0.0.0.0/0" --query "SecurityGroups[*].{ID:GroupId}" | grep ID | awk '{print $2}' | sed 's/"//g' | sed 's/,//g'`; do echo $i; aws ec2 describe-network-interfaces --filters "Name=group-id,Values=$i" --profile="Prod" --region=us-east-1 | grep Description; done
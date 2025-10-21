## Network Architecture

### CIDR Block Design
- VPC: 10.0.0.0/16 (65,536 IPs - enterprise scalability)
- Public Subnet:  10.0.1.0/24 (251 usable IPs)
- Private Subnet: 10.0.10.0/24 (251 usable IPs)

**Rationale**: /16 VPC allows future multi-tier expansion (database 
tier, caching layer, additional availability zones). /24 subnets 
support 100+ resources per tier with room for growth.

### Traffic Flow Design
Internet → IGW → Public Subnet (Nginx) → Private Subnet (App Servers)
Private Subnet → NAT Gateway → IGW → Internet (outbound only)

**Security Philosophy**: Defense-in-depth with 4 layers:
1. Internet Gateway (entry control)
2. NACLs (subnet-level stateless filtering)
3. Security Groups (instance-level stateful filtering)
4. IAM (user/service access control)

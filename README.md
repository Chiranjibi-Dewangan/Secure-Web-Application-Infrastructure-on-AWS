# 🔒 Production-Grade AWS Secure Infrastructure

**Business Problem**: Organizations need infrastructure that separates 
public services from private operations while enforcing security at 
multiple layers.

**Solution**: Designed and deployed enterprise-grade AWS architecture 
with VPC isolation, multi-layer security (IGW→NACL→SG→IAM), and 
role-based access control.

**Impact**: Zero-trust network supporting 250+ IPs per subnet with 
defense-in-depth security—production-ready in 7 days.

[Architecture Diagram Coming] 
![Infrastructure Architecture](Infrastructure%20Architecture%20.jpeg)

## Tech Stack
AWS VPC | EC2 | IAM | S3 | Security Groups | NACLs | NAT Gateway


## Project Context

**Scenario**: Deploy secure web infrastructure requiring:
- Public-facing nginx servers accessible from internet
- Private application tier isolated from direct internet access
- Separation of duties: Admins manage infrastructure, Dev group have view only access
- Cost-efficient design using AWS free tier where possible

**Success Criteria**:

✓ Public EC2 accessible via HTTP from anywhere

✓ Private EC2 accessible ONLY via public EC2 (bastion pattern)

✓ Private EC2 has internet access via NAT (for updates)

✓ Admin users control all resources, Dev users read-only to EC2

✓ S3 static website demonstrates multi-service integration

# Deployment Log

## Step 1: VPC Creation (10:30 AM)
**Action**: Created VPC via AWS Console
**Configuration**:
- Name: prod-web-vpc
- CIDR: 10.0.0.0/16
- Tenancy: Default
- DNS hostnames: Enabled
- DNS resolution: Enabled

**Screenshot**: [vpc-creation.png](../screenshots/vpc/vpc-creation.png)

**Result**: VPC ID vpc-072ed8cd131c6d619 created successfully

**Why DNS enabled**: Allows instances to resolve public DNS names for 
package installations and updates.

**Time**: 5 minutes



# 🧠 Critical Findings & Learnings

---

## Issue Encountered: NAT Gateway Route Delay

**Symptom**: Private route table created but NAT route not working

**Investigation**: 
- Verified NAT Gateway in public subnet ✓
- Checked Elastic IP association ✓
- Tested immediately after creation ✗

**Root Cause**: NAT Gateway takes 2-3 minutes to become "available" 
status

**Solution**: Waited for status change, then route worked

**Learning**: Always check resource status before testing connectivity

**Prevention**: Script could include status check before route addition

**Time to resolve**: 5 minutes roughly



## 1. DNS Settings (CRITICAL – Often Missed)

✅ **Enabled DNS Hostnames**  
- Allows EC2 instances to receive public DNS hostnames.  
- Required for public instances to work properly when assigned public IPs.

---

## 2. Subnet IP Settings

✅ **Enable Auto-Assign Public IPv4 Address**  
- Without this setting, EC2 instances launched in the public subnet won’t automatically receive public IPs.  
- Critical for external SSH access and serving web traffic.

---

## 3. Design Constraint – Cost-Efficient Free Tier Architecture

**Primary Constraint:** Build entirely within AWS Free Tier limits.  

**Finding:**  
High Availability (HA) typically requires:  
- Multi-AZ deployment (2+ subnets in different Availability Zones)  
- Additional NAT Gateway (~$32/month)  
- Application Load Balancer (~$16/month)  
- Auto Scaling Groups setup  

💰 **Estimated Extra Cost:** ~$50–70/month beyond Free Tier.  

**Decision:**  
Deployed all resources within a **single Availability Zone** (same AZ for public and private subnets).  
> Trade-off: Lower availability but significant cost savings — acceptable for a learning or demo environment.  
> **Best practice:** Always prefer Multi-AZ for production workloads.

---

## 4. Network ACLs – Critical Learning

### Issue:
While hardening the **Public Subnet NACLs**, outbound requests from my EC2 instance kept hanging (`yum update` and external API calls failed) — even though routes and Security Groups looked correct.

### Root Cause:
Custom NACLs are **stateless**, meaning they don’t automatically allow return traffic for outbound connections.  
Response packets arrive on **ephemeral ports (1024–65535)**, which were being **dropped**.

### Fix:
Added **Inbound NACL Rule** allowing:

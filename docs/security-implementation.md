# Security Implementation


### Security Group Design Principle: Defense-in-Depth with Least Privilege

Security Groups implement **instance-level stateful filtering**, allowing only necessary traffic while blocking everything else by default. Each tier has purpose-specific rules that enforce isolation between public and private resources.

---

## Public Web Security Group (public-web-sg)

**Purpose**: Allow HTTP/HTTPS from internet, SSH from my IPs only. Protect public-facing Nginx web servers.  
**Security Group ID**: sg-065b9beb2c44d196a

**Security Principle**: Least privilege SSH limited to admin IP, not 
0.0.0.0/0

### Inbound Rules

| Type | Protocol | Port | Source | Justification |
|------|----------|------|--------|---------------|
| HTTP | TCP | 80 | 0.0.0.0/0 | Public web access required |
| HTTPS | TCP | 443 | 0.0.0.0/0 | Secure web access (future SSL) |
| SSH | TCP | 22 | 106.215.149.177/32 | Admin access only - least privilege |

### Outbound Rules

| Type | Protocol | Port | Destination | Justification |
|------|----------|------|-------------|---------------|
| All | All | All | 0.0.0.0/0 | Package updates, DNS, return traffic |

### Security Rationale

**Why SSH limited to admin IP**: 
- Implements **least privilege principle**
- Prevents brute force SSH attacks from internet
- Only authorized admin IP can manage servers

**Why HTTP/HTTPS open to world**:
- Public web servers must serve traffic to anyone
- This is the intended function (controlled exposure)

**Stateful Advantage**:
- Return traffic for allowed inbound connections automatically permitted
- No need to explicitly allow outbound HTTP responses

---

## Private App Security Group (private-app-sg)

**Purpose**: Allow traffic ONLY from public subnet and Protect private backend application servers  
**Security Group ID**: sg-0da30262177e0a850

### Inbound Rules

| Type | Protocol | Port | Source | Justification |
|------|----------|------|--------|---------------|
| Custom TCP | TCP | 8080 | public-web-sg | App traffic from web tier ONLY |
| SSH | TCP | 22 | public-web-sg | Bastion access pattern |

### Outbound Rules

| Type | Protocol | Port | Destination | Justification |
|------|----------|------|-------------|---------------|
| All | All | All | 0.0.0.0/0 | Updates via NAT, API calls |


**Security Principle**: Private instances completely isolated from 
direct internet access and accessible only through public tier.

### Security Rationale

**Why source is Security Group, not IP**:
- **Dynamic security**: New Nginx instances automatically get access
- **Maintainable**: No hardcoded IPs to update
- **AWS best practice**: Source-based rules scale better

**Why NO 0.0.0.0/0 sources**:
- Private instances completely isolated from internet
- Cannot be accessed directly from outside
- Defense-in-depth: Even if private instance gets public IP by accident, SG blocks access

**Bastion Pattern**:
- SSH only from public-web-sg (bastion hosts)
- Admins must: SSH to public instance → SSH to private instance
- Industry standard for production security

---

## Network ACL Configuration

### Public Subnet NACL (public-nacl)

**NACL ID**: acl-04860a2fe4823443b  
**Associated Subnet**: public-subnet-1 (10.0.1.0/24)

#### Inbound Rules

| Rule # | Type | Protocol | Port | Source | Allow/Deny | Purpose |
|--------|------|----------|------|--------|------------|---------|
| 100 | HTTP | TCP | 80 | 0.0.0.0/0 | ALLOW | Public web traffic |
| 110 | HTTPS | TCP | 443 | 0.0.0.0/0 | ALLOW | Secure web traffic |
| 120 | SSH | TCP | 22 | YOUR-IP/32 | ALLOW | Admin access |
| 130 | Custom | TCP | 1024-65535 | 0.0.0.0/0 | ALLOW | Return traffic (ephemeral) |
| * | All | All | All | 0.0.0.0/0 | DENY | Default deny |

#### Outbound Rules

| Rule # | Type | Protocol | Port | Destination | Allow/Deny | Purpose |
|--------|------|----------|------|-------------|------------|---------|
| 100 | HTTP | TCP | 80 | 0.0.0.0/0 | ALLOW | Package downloads |
| 110 | HTTPS | TCP | 443 | 0.0.0.0/0 | ALLOW | Secure outbound |
| 120 | Custom | TCP | 1024-65535 | 0.0.0.0/0 | ALLOW | Response traffic |
| * | All | All | All | 0.0.0.0/0 | DENY | Default deny |

---

### Private Subnet NACL (private-nacl)

**NACL ID**: acl-09009d30cc6fbeee4  
**Associated Subnet**: private-subnet-1 (10.0.10.0/24)

#### Inbound Rules

| Rule # | Type | Protocol | Port | Source | Allow/Deny | Purpose |
|--------|------|----------|------|--------|------------|---------|
| 100 | Custom | TCP | 8080 | 10.0.1.0/24 | ALLOW | App traffic from public tier |
| 110 | SSH | TCP | 22 | 10.0.1.0/24 | ALLOW | Bastion SSH access |
| 120 | Custom | TCP | 1024-65535 | 10.0.1.0/24 | ALLOW | Return traffic from public |
| * | All | All | All | 0.0.0.0/0 | DENY | Default deny |

#### Outbound Rules

| Rule # | Type | Protocol | Port | Destination | Allow/Deny | Purpose |
|--------|------|----------|------|-------------|------------|---------|
| 100 | Custom | TCP | 1024-65535 | 10.0.1.0/24 | ALLOW | Responses to public tier |
| 110 | HTTPS | TCP | 443 | 0.0.0.0/0 | ALLOW | Updates via NAT |
| 120 | HTTP | TCP | 80 | 0.0.0.0/0 | ALLOW | Package downloads via NAT |
| * | All | All | All | 0.0.0.0/0 | DENY | Default deny |

---


## Security Group vs NACL Comparison

| Feature | Security Group | NACL |
|---------|----------------|------|
| **Layer** | Instance-level | Subnet-level |
| **State** | Stateful (return traffic auto-allowed) | Stateless (explicit rules required) |
| **Rules** | Allow rules only | Allow + Deny rules |
| **Evaluation** | All rules evaluated | Rules evaluated in order |
| **Applies To** | Individual ENIs/instances | Entire subnet |
| **Return Traffic** | Automatic | Must explicitly allow |

### Why Both?

**Defense-in-depth**: Two independent security layers
- NACL provides **subnet-level perimeter** (coarse filtering)
- Security Group provides **instance-level firewall** (fine-grained control)
- If one is misconfigured, the other still protects

Together they implement **multiple independent security layers**—production security standard.

---


## Defense-in-Depth Strategy

**Layer 1: Internet Gateway**
- Controls all traffic entering/leaving VPC
- Provides NAT for public IP assignment

**Layer 2: Network ACLs**
- Subnet-level stateless filtering
- Explicit deny rules block unwanted traffic
- Rule ordering enforces priority

**Layer 3: Security Groups**
- Instance-level stateful filtering
- Source-based rules (e.g., only from specific SG)
- Automatic return traffic handling

**Layer 4: IAM**
- Controls WHO can modify infrastructure
- Separates admin and developer permissions
- MFA required for sensitive operations

**Production Readiness**: This 4-layer approach meets enterprise 
security standards and could pass basic compliance audits.



## Security Best Practices Implemented

 **Least Privilege**: SSH limited to admin IP, not world  
 
 **Source-Based Security**: Private SG references public SG, not IPs  
 
 **Defense-in-Depth**: NACL + Security Group layers  
 
 **Bastion Pattern**: Private instances accessible only via jump box  
 
 **Stateful Where Possible**: Security Groups simplify rule management  
 
 **Deny by Default**: Both NACLs and SGs deny unless explicitly allowed  
 
 **Subnet Isolation**: NACLs ensure subnet-level boundaries  

**Production Readiness**: This multi-layer security approach meets enterprise standards and basic compliance requirements.standards and basic compliance requirements.[1]

---

✅  **Security Layer Status**: COMPLETE  

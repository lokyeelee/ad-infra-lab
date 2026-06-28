# Building Small Enterprise Infrastructure with Windows Server and Active Directory

A Windows infrastructure lab built in **VirtualBox** to simulate a small enterprise environment. The project demonstrates centralized identity, networking, storage, and endpoint management using **Windows Server 2025**.

## 1. Overview

This lab simulates a small enterprise consisting of **IT** and **Sales** departments. A single Windows Server provides centralized infrastructure services including **Active Directory**, **DNS**, **DHCP**, **RRAS**, **File Services**, **Group Policy**, and **Windows LAPS**.

<img width="600" height="480" alt="image" src="https://github.com/user-attachments/assets/b7748fa3-ec56-40b8-a3ad-70f033a66819" />


### Infrastructure Summary

| Component | Implementation |
|-----------|----------------|
| Identity | Active Directory Domain Services |
| DNS | AD-integrated DNS + Forwarders |
| DHCP | Two DHCP Scopes |
| Routing & Internet Access | RRAS + NAT |
| Network | Two Private Subnets |
| Storage | Dynamic Volume (using 5 Virtual Disks) |
| File Services | Department Network Shares |
| Endpoint Management | Group Policy + Windows LAPS |

## 2. Infrastructure Design

### 2.1 Network Architecture
| Network | Subnet | Purpose |
|---------|--------|---------|
| IT | 192.168.10.0/24 | IT department |
| Sales | 192.168.20.0/24 | Sales department |
| NAT/Public | VirtualBox NAT | Outbound Internet access |

<img width="800" height="400" alt="image" src="https://github.com/user-attachments/assets/a1432262-0e8d-4553-93b5-1d44df873610" />

The Windows Server is configured with:

- **Two private subnets** for separate department networks
  - Two internal NICs
- **NAT** for outbound connectivity
  - One public NIC (VirtualBox NAT)
- **RRAS** for inter-subnet routing and Internet access
- **DHCP** scopes for both subnets
- **AD-integrated DNS** with Cloudflare (`1.1.1.1`) and Google (`8.8.8.8`) configured as forwarders

Clients can communicate across subnets while using the server as their default gateway.

### Design Decisions

- Segmented the network into two subnets to emulate departmental separation.
- Used RRAS instead of dedicated routing appliances to keep the lab self-contained while demonstrating Windows routing and NAT.
- Centralized DNS and DHCP services to reflect a typical small business deployment.

## 3. Active Directory Design

The Active Directory environment is organized using **department-based Organizational Units** and **security groups** to simplify administration and policy-based management.

<img width="700" height="380" alt="image" src="https://github.com/user-attachments/assets/695fafb6-c245-4bb3-ac80-9267311394d7" />

## 4. Endpoint Management Using GPOs

Group Policy is used to centrally configure domain-joined workstations.

### 4.1 Department Drive Mapping

<img width="650" height="250" alt="image" src="https://github.com/user-attachments/assets/f45f6291-1fc2-44cc-b01c-5fa8b23c8c74" />

Network drives are automatically mapped according to department security group membership, ensuring users in Sales and IT department can access their department drive after signing in.

### 4.2 Windows LAPS

<img width="650" height="250" alt="image" src="https://github.com/user-attachments/assets/3c23c003-e681-426e-beb1-313a8b891b16" />


Windows LAPS automatically manages a unique local administrator password for each workstation and stores it securely in Active Directory. A local administrator account named `lapsadmin` is created using a startup script `create-local-admin.ps` through GPO.

Together, **DesktopAdmin** and **Windows LAPS** provide both operational administration and secure emergency access.

### 4.3 Local Administrator Delegation

<img width="650" height="300" alt="image" src="https://github.com/user-attachments/assets/09d632cc-bee2-4e6c-a312-e1f764f7398e" />

A domain security group (`svg-DesktopAdmin`) is automatically added to the local **Administrators** group in all domain-joined computers, allowing authorized IT staff to manage workstations without manual configuration.

## 5. Storage & File Services

Departmental file shares are hosted on a **Dynamic Volume** created from **five virtual disks**, separating user data from the operating system volume.

<img width="600" height="430" alt="image" src="https://github.com/user-attachments/assets/a88f6ed4-86f9-4b97-a1f9-e585bdb8007f" />

Folder access is controlled using **NTFS permissions** together with **Active Directory security groups**.

| Security Group | Network drive for IT department | Network drive for Sales department |
|----------------|----------------------------------|------------------------------------|
| `sg-Dept-IT` | Modify | No Access |
| `sg-Dept-Sales` | No Access | Modify |

The file server, Active Directory, Group Policy, and NTFS permissions work together to provide automated and role-based access to departmental resources.

## 6. Limitations

This project is intended to demonstrate **core Windows infrastructure administration** rather than replicate a production enterprise environment.

Current scope includes:

- Single Windows Server hosting multiple infrastructure roles
- Two department networks (**IT** and **Sales**)
- Centralized file services on a single server
- No high availability, DFS, clustering, or enterprise network appliances

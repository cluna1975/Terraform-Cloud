# Diagrama de Infraestructura AWS - Práctica 6

## Arquitectura Actual

```
┌─────────────────────────────────────────────────────────────────────┐
│                           AWS Region: us-east-1                     │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────────┐│
│  │                    VPC Virginia (10.10.0.0/16)                 ││
│  │                                                                 ││
│  │  ┌─────────────────────────────────┐                           ││
│  │  │      Public Subnet              │                           ││
│  │  │     (10.10.0.0/24)             │                           ││
│  │  │                                 │                           ││
│  │  │  ┌─────────────────────────┐   │                           ││
│  │  │  │    EC2 Instance         │   │                           ││
│  │  │  │   (ec2_public)          │   │                           ││
│  │  │  │   AMI: ami-07ff62358... │   │                           ││
│  │  │  │   Type: t3.micro        │   │                           ││
│  │  │  │   Key: clunaKeyaws      │   │                           ││
│  │  │  │   Public IP: Auto       │   │                           ││
│  │  │  └─────────────────────────┘   │                           ││
│  │  └─────────────────────────────────┘                           ││
│  │                    │                                            ││
│  │                    │                                            ││
│  │  ┌─────────────────────────────────┐                           ││
│  │  │     Private Subnet              │                           ││
│  │  │     (10.10.1.0/24)             │                           ││
│  │  │     (Sin recursos)              │                           ││
│  │  └─────────────────────────────────┘                           ││
│  │                                                                 ││
│  │  ┌─────────────────────────────────┐                           ││
│  │  │    Internet Gateway             │                           ││
│  │  │    (igw vpc virginia)           │                           ││
│  │  └─────────────────────────────────┘                           ││
│  │                    │                                            ││
│  │  ┌─────────────────────────────────┐                           ││
│  │  │    Route Table (Public)         │                           ││
│  │  │    0.0.0.0/0 → IGW             │                           ││
│  │  └─────────────────────────────────┘                           ││
│  │                                                                 ││
│  │  ┌─────────────────────────────────┐                           ││
│  │  │    Security Group               │                           ││
│  │  │    (Public Instance SG)         │                           ││
│  │  │    Ingress: SSH (22) from 0/0   │                           ││
│  │  │    Egress: All traffic          │                           ││
│  │  └─────────────────────────────────┘                           ││
│  └─────────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │
                            ┌───────────────┐
                            │   Internet    │
                            └───────────────┘
```

## Componentes de la Infraestructura

### Red (VPC)
- **VPC Virginia**: `10.10.0.0/16`
- **Public Subnet**: `10.10.0.0/24` (con auto-asignación de IP pública)
- **Private Subnet**: `10.10.1.0/24` (sin recursos actualmente)

### Conectividad
- **Internet Gateway**: Proporciona acceso a Internet
- **Route Table**: Ruta pública que dirige todo el tráfico (0.0.0.0/0) al IGW
- **Route Table Association**: Asocia la subnet pública con la tabla de rutas

### Seguridad
- **Security Group**: "Public Instance SG"
  - Ingress: SSH (puerto 22) desde cualquier IP (0.0.0.0/0)
  - Egress: Todo el tráfico permitido

### Compute
- **EC2 Instance**: "ec2_public"
  - Tipo: t3.micro
  - AMI: ami-07ff62358b87c7116
  - Key Pair: clunaKeyaws
  - Ubicación: Public Subnet
  - IP Pública: Asignada automáticamente

### Tags Aplicados
- Environment: dev
- Owner: CLUNA
- Cloud: AWS
- IAC: Terraform
- IAC Version: 1.1.0
- Project: LUNERUS

## Flujo de Tráfico

1. **Tráfico Entrante**: Internet → IGW → Route Table → Public Subnet → EC2 Instance
2. **Tráfico Saliente**: EC2 Instance → Public Subnet → Route Table → IGW → Internet
3. **Acceso SSH**: Permitido desde cualquier IP a través del puerto 22

## Notas
- La subnet privada está configurada pero no tiene recursos desplegados
- La instancia EC2 tiene acceso completo a Internet
- El Security Group permite SSH desde cualquier ubicación (considerar restringir por seguridad)
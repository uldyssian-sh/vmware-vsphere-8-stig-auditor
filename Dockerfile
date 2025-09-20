FROM mcr.microsoft.com/powershell:latest

# Install VMware PowerCLI
RUN pwsh -Command "Set-PSRepository PSGallery -InstallationPolicy Trusted; Install-Module -Name VMware.PowerCLI -Force -Scope AllUsers"

# Create app directory
WORKDIR /app

# Copy application files
COPY vmware-vsphere-8-stig-auditor.ps1 ./
COPY examples/ ./examples/
COPY docs/ ./docs/

# Create output directory for reports
RUN mkdir -p /app/reports

# Set environment variables
ENV POWERSHELL_TELEMETRY_OPTOUT=1
ENV VMWARE_POWERCLI_CEIP_SETTING=ParticipateInCEIP:$false

# Create entrypoint script
RUN echo '#!/usr/bin/pwsh' > /app/entrypoint.ps1 && \
    echo 'param($VCenter, $Username, $Password, $SkipVCenterChecks)' >> /app/entrypoint.ps1 && \
    echo 'if (-not $VCenter) { Write-Host "Usage: docker run vmware-vsphere-8-stig-auditor -VCenter vcenter.company.com"; exit 1 }' >> /app/entrypoint.ps1 && \
    echo '$params = @{ VCenter = $VCenter }' >> /app/entrypoint.ps1 && \
    echo 'if ($Username) { $params.Username = $Username }' >> /app/entrypoint.ps1 && \
    echo 'if ($Password) { $params.Password = (ConvertTo-SecureString $Password -AsPlainText -Force) }' >> /app/entrypoint.ps1 && \
    echo 'if ($SkipVCenterChecks) { $params.SkipVCenterChecks = $true }' >> /app/entrypoint.ps1 && \
    echo '& /app/vmware-vsphere-8-stig-auditor.ps1 @params' >> /app/entrypoint.ps1 && \
    chmod +x /app/entrypoint.ps1

# Default command
ENTRYPOINT ["/app/entrypoint.ps1"]
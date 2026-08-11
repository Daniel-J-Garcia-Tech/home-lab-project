Remote Monitoring & Management (RMM) Deployment
Self-Hosted RMM deployment and fleet operation within the air-gapped homelab, using Tactical RMM. This project extends the lab from static infrastructure into centrally monitored and managed endpoints. With an emphasis on doing it within the air-gap constraints.
Overview
Deployed a self-hosted Tactical RMM server and enrolled multiple Windows endpoints as managed agents, then configured monitoring, alerting, patch-compliance scanning, and bulk script execution. The goal was to practice the day-to-day work of endpoint monitoring and management, as well to understand where those tools succeed and fail in an air-gapped environment. Environment: Proxmox VE Host, isolated internal VM network, managed via a deliberate on-demand connectivity toggle.
What was Built
RMM Server
    • Deployed Tactical RMM (Django/ Vue/Go stack: PostgreSQL, Redis, NATS, nginx, MeshCentral) on dedicated Ubuntu Server VM.
    • Installed using the –insecure self-signed-certificate path, since the lab uses internal DNS names with no public certificate authority.
    • Configured internal DNS resolution on the domain controller (dedicated lab.local forward-lookup zone with rmm/api/mesh A records) so agents resolve the server by name. Controlled Internet Access (Air-Gap Preservation)
    • The lab is air-gapped by default. Rather than open the whole network for installs, built an on-demand NAT rule scoped to a single host (iptables MASQUERADE) plus IP forwarding, so only the RMM server could reach the internet, and only while manually toggled on.
    • Internet access was enabled deliberately for install/update tasks and disabled afterwards to reseal the network. This mirrors the real-world “stage connected, then isolate” life-cycle for secure systems.
Managed Endpoints
    • Deployed agents to two Windows endpoints: a Windows 10 workstation, and a Windows Server domain controller.
    • Handled agent installation in the air-gapped context by retrieving the generic agent installer on a connected host and serving it to the target machines over the internal network.
Monitoring & Altering
    • Configured disk-space checks with free-space thresholds and consecutive failure altering logic.
    • Configured Windows service monitoring, and validated altering behavior by inducing a failure and confirming the check flipped to failed and recovered, verifying the monitor actually fires.
Patch Compliance
    • Ran patch compliance scans against the endpoints.
    • Documented that patch scanning fails without an internal update source in an air-gapped environment. The agent cannot reach Windows Update/WSUS to determine missing patches. This is a constraint that makes air-gapped patch management a specialized workflow.
Centralized Script Execution
    • Loaded custom Powershell automation (system health-check reporting) into the RMM’s central library.
    • Adapted script for remote execution, using Write-Output rather than Write-Host, so results return correctly to the console.
    • Executed scripts against a single agent, then ran a bulk script across both VM’s, with each endpoint returning its own results.
Deliberate Scope Decision: Linux Agent Not Deployed
Tactical RMM’s Linux and macOS agents require code-signed binaries available only through a paid monthly sponsorship. The only no cost path is an unofficial, unsupported third-party install script.
I chose not to deploy Linux agent. Running an unvetted third-party script on lab infrastructure was not a trade off I was willing to make for learning, and paying a recurring subscription for a homelab was not warranted. The fleet was therefore scoped to the two Windows endpoints.
Troubleshooting Encountered
    • Agent installer blocked by air-gap: the “download agent” function pulls the binary from the internet, which the isolated endpoints cannot reach. Resolved by fetching the generic installer on a connected host and serving it internally.
    • OS compatibility: the server installer supported an older Ubuntu release than the one in use. Made a documented decision to widen the version check for a lab install. Understanding this is an unsupported configuration.
    • Self-signed certificate handling: the dashboard front-end and API each present separate self-signed certificates that must both be accepted by the browser before the interface functions.
Skills Demonstrated
    • Self-hosted application deployment (multi-service stack) in a constrained/isolated environment
    • Air-gap-preserving network design (scoped, toggle-able NAT; internal DNS; internal file distribution)
    • Endpoint monitoring and alert threshold configuration, with verification of alerting behavior
    • Understanding of why standard patch tooling fails air-gapped
    • Centralized, fleet-wide script execution and RMM-appropriate script authoring
    • Systematic troubleshooting (licensing, DNS dependencies, certificates, connectivity)
    • Security judgment: declined to run untrusted third-party code

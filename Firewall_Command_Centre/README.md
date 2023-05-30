###  <u> Azure Firewall Command Centre </u>
This is sample [Azure Managed Grafana](https://learn.microsoft.com/en-us/azure/managed-grafana/) based dashboard for tracking multiple Azure Firewall (in this case two) logs and metric in near real-time basis from Log Analytics. 

This assets helps SOC/NOC/SRE/InfoSec ir even Priject team to understand current behaviour, loggic and monitoring how requests are handled by Azure Firewall and Policies. 
Main objective was to bring maximum but most relevant information in front of operators. Thus, this dashboard provide pan of glass visualization of key Metrics and Key Logs. 
Using Grafan auto-refresh capability, dashboard sharing and Playlist etc, it's usage can be extended.
<u> *Same capabilities can be achieved by writting [Azure Workbook](https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview)*</u>

<img src="/Firewall_Command_Centre/AzFw_Command_Centre.jpg" alt="AzFw_Command_Centre" width=30% height=30%>

In order to enable automated Azure Firewall Diagnostics Setting, Azure Landing Zone Custom Policy Set Defition is being used. 
- [Here is Guidance](https://github.com/Azure/ALZ-Bicep/blob/main/infra-as-code/bicep/modules/policy/definitions/README.md) to deploy policy (in case not deployed as part Azure Landing Zone)
- Policy Set Defintion Used to deploy [Diagnostic Settings](https://github.com/Azure/ALZ-Bicep/blob/main/infra-as-code/bicep/modules/policy/definitions/lib/policy_set_definitions/policy_set_definition_es_Deploy-Diagnostics-LogAnalytics.json) as part of Policy Assignment.

#### Usage Guidance
- Using [Import a Dashboard](https://grafana.com/docs/grafana/latest/dashboards/manage-dashboards/#import-a-dashboard)
- Ensure you update Scope and Resources Selection so that you get telementry data only 
<img src="/Firewall_Command_Centre/Steps.jpg" alt="Steps" width=25% height=25%>
- After that save your Dashboard version and start reviewing logs.

*Note: This is first version and more of knowledge sharing. Effort to maintained will be limited. If you feel something more be added or fixe, please do PR. Open for suggestion. I have thing in backlog to make it more feature rich.*

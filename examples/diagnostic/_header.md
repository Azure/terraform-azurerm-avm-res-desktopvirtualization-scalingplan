# Diagnositc example

This deploys the module with Diagnostic settings enabled to send logs to a storage account.

Azure Virtual Desktop requires a subscription-scoped **Desktop Virtualization Power On Off Contributor** assignment before a scaling plan can be associated with a host pool. For CI end-to-end tests, `pre.ps1` enables the example's optional role assignment only when the selected subscription is listed in `TEST_SUBSCRIPTION_IDS`. For manual use, configure the required permission yourself or explicitly set `create_role_assignment = true` in an isolated test subscription.

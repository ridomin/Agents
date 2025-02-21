# Deploy

## Azure and M365 permissions

## Development Environment

1. Azure CLI
1. DevTunnels
1. [Optional] Docker Tools for container based deployment
1. Runtime and SDK per language

### localhost anonymous

Expose the bot endpoint /api/message in localhost.
 - anonymous, local network only

### ABS WebChat with DevTunnels

1. Create EntraID application

az ad app create

2. Create persistent tunnel

> [Tip!]
> You can reuse the same tunnel and EntraID app registration to run multiple samples in localhost, one at a time.

Save a .env file corresponding o that environment.




## Integration Tests

## Production
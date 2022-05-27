# Salesforce App

## Some Resources

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)

## Commands

### Development

```
yarn install
```

Log in to the devhub org and give it the og alias

```
sfdx auth:web:login -a og
```

Create a scratch org and give it alias og-scratch

```
sfdx force:org:create edition=Developer -s -a og-scratch -v og
```

Push code to scratch org

```
sfdx force:source:push -u og-scratch
```

Open the scratch org in a browser

```
sfdx force:org:open -u og-scratch
```

Pull code changes from the scratch org

```
sfdx force:source:push -u og-scratch
```

To test your changes locally, change the url in the namedCredential to the `WEBHOOK_URL` you use for oneserve. But **BE VERY CAREFUL** not to push that change in the production package. TODO(dww) Can I write a test that the named credential is oneserve.onegraph.com

### Testing and Linting

PMD scanner in vscode:
[https://marketplace.visualstudio.com/items?itemName=chuckjonas.apex-pmd](https://marketplace.visualstudio.com/items?itemName=chuckjonas.apex-pmd)

sfdx-scanner cli tool:

```
sfdx plugins:install @salesforce/sfdx-scanner
sfdx scanner:run --target package/
```

### Create new beta package

**be sure this will work, because we can only do it 5 times a day\***

You can run `force:package:version:create` with `--skipvalidation` to test more variations, but make sure the package you release wasn't created that way.

First, update versions in `sfdx-project.json` and OneGraphPackageVersion:

- Set version num to be larger than the last, e.g. 0.2.0.0
- Set ancestorVersion to be the last released package version or people won't be able to upgrade
- Update versionName
- Update version and versionString in the OneGraphPackageVersion (sorry that this isn't automatic)

Test that it will build
```
sfdx force:package:version:create --package "OneGraph GraphQL Subscriptions" --skipvalidation --installationkeybypass -v og
```

Create a beta version
```
sfdx force:package:version:create --package "OneGraph GraphQL Subscriptions" --codecoverage --installationkeybypass -v og
```
Install it in a salesforce org and make sure it works.


# Release a package

Replace 04t6g000008jkMEAAY with the package id from the last command
sfdx force:package:version:promote -p 04t6g000008jln6AAA

## Latest version install url

AppExchange URL: https://appexchange.salesforce.com/appxListingDetail?listingId=a0N3A00000G0yipUAB

Direct URL: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t6g000008jln6AAA

Quote Expansion URL: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t6g000008jlcMAAQ

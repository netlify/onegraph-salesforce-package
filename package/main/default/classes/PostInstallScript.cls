global class PostInstallScript implements InstallHandler {
  global void onInstall(InstallContext context) {
    if (context.previousVersion() == null) {
      OneGraphToggleSettings.initWithAllDisabled();
    }
  }
}

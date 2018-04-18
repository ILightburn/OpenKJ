function Component()
{
    // constructor
}

Component.prototype.isDefault = function()
{
    // select the component by default
    return true;
}

Component.prototype.createOperations = function()
{
    try {
        // call the base create operations function
        component.createOperations();
    } catch (e) {
        print(e);
    }

    if (installer.value("os") === "win") {
        component.addOperation("CreateShortcut", "@TargetDir@/OpenKJ.exe", "@StartMenuDir@/OpenKJ.lnk");
        component.addOperation("Execute", "@TargetDir@/vcredist_x64.exe", "/quiet", "/norestart");
    }
}

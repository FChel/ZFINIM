sap.ui.define([
    "sap/ui/core/mvc/Controller"
], function (Controller) {
    "use strict";

    return Controller.extend("defence.finance.finux.im.controller.App", {

        onInit: function () {
            // Apply content density mode
            this.getView().addStyleClass(
                this.getOwnerComponent().getContentDensityClass()
            );
        }
    });
});

({
	handleModeSelectEvent : function(component, event, helper) {
		var mode = event.getParam("modeName");

    if (mode === "all") {
			var allCopyDiv = component.find("allCopyDiv");
			$A.util.addClass(allCopyDiv,"slds-show");
			$A.util.removeClass(allCopyDiv,"slds-hide");

			var partCopyDiv = component.find("partCopyDiv");
			$A.util.addClass(partCopyDiv,"slds-hide");
			$A.util.removeClass(partCopyDiv,"slds-show");

			helper.fetchQuoteHelper(component);
		}

		else if (mode === "part"){
			var allCopyDiv = component.find("allCopyDiv");
			$A.util.addClass(allCopyDiv,"slds-hide");
			$A.util.removeClass(allCopyDiv,"slds-show");

			var partCopyDiv = component.find("partCopyDiv");
			$A.util.addClass(partCopyDiv,"slds-show");
			$A.util.removeClass(partCopyDiv,"slds-hide");

			helper.fetchQuoteHelper(component);
		}
	},

	handleChangeOppEvent : function(component, event, helper) {
		var oppId = event.getParam("oppByEvent").Id;
		component.set("v.oppId",oppId);
	},

	oppChange : function(component, event, helper) {
		helper.fetchQuoteHelper(component);
	}
})
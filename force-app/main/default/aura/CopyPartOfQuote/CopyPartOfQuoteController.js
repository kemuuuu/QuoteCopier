({
	handleOnRowSelection : function(component, event, helper) {
		var selectedRows = event.getParam("selectedRows");
		component.set("v.selectedQuotes",selectedRows);
	},

	handleButtonClick : function(component, event, helper) {
		var sp = component.find("mySpinner");
		$A.util.addClass(sp, "slds-show");
		$A.util.removeClass(sp, "slds-hide");
		
		helper.partCopyHelper(component, event);
	}
})
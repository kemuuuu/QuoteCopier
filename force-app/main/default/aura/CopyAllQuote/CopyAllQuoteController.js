({
	handleClick : function(component, event, helper) {

		var sp = component.find("mySpinner");
		$A.util.addClass(sp, "slds-show");
		$A.util.removeClass(sp, "slds-hide");

		helper.allCopyHelper(component, event);
	}
})
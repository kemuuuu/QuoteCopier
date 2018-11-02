({
	selectOpportunity : function(component, event, helper) {
		var getSelectedOpp = component.get("v.opp");
		var compEvt = component.getEvent("selectedOppEvent");
		compEvt.setParams({"oppByEvent" : getSelectedOpp});
		compEvt.fire();
	}
})
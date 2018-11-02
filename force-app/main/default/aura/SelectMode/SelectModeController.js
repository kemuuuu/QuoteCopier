({
	handloChange : function(component, event, helper) {
		var radioval = component.get("v.radioGrpValue");
		var compEvt = component.getEvent("mySelectModeEvent");
		compEvt.setParams({"modeName":radioval});
		compEvt.fire();
	}
})
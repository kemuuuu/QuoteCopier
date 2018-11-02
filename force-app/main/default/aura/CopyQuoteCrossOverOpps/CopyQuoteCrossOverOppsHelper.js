({
	fetchQuoteHelper : function(component) {
		var oppId = component.get("v.oppId");
		var action = component.get("c.fetchQuotes");
		action.setParams({
			"oppId" : oppId
		});
		action.setCallback(this, function(res) {
			var state = res.getState();
			if (state === "SUCCESS") {
				component.set("v.quotes",res.getReturnValue());
				component.set("v.columns", [
					{label : '見積名', fieldName : 'Name', type : 'text'},
					{label : '小計', fieldName : 'Subtotal', type : 'currency'},
				]);
			}
			else {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
						title : 'Error Message',
						message:'商談検索に失敗しました',
						messageTemplate: 'Mode is pester ,duration is 5sec and Message is overrriden',
						duration:' 5000',
						key: 'info_alt',
						type: 'error',
						mode: 'pester'
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	}
})
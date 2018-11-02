({
	callClone : function(c) {
		var action = c.get('c.copyQuote');
		var thisId = c.get('v.recordId');
		action.setParams({
			"originalId" : thisId
		});
		action.setCallback(this, function(res){

			var state = res.getState();
			if (state === "SUCCESS") {
				location.href = "/lightning/r/Quote/"+res.getReturnValue()+"/view";
			}
			else if (state === "ERROR") {
				var sp = c.find("mySpinner");
				$A.util.addClass(sp, "slds-hide");
				$A.util.removeClass(sp, "slds-show");

				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
                    title : 'Error Message',
                    message:'見積コピーに失敗しました',
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
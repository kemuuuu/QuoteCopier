({
	allCopyHelper : function(cmp, ev) {
		var myId = cmp.get("v.myOppId");
		var oppId = cmp.get("v.oppId");
		var action = cmp.get('c.copyAllQuote');
		action.setParams({
				"targetOppId" : oppId,
				"myOppId" : myId
		});
		action.setCallback(this, function(res) {
			var state = res.getState();
			if (state === "SUCCESS") {
				location.href = "/lightning/r/Opportunity/"+myId+"/view";
			}
			else {
				var sp = cmp.find("mySpinner");
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
				$A.get("e.force:closeQuickAction").fire();
			}
		});
		$A.enqueueAction(action);
	}
})
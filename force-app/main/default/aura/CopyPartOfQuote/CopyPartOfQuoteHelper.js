({
	partCopyHelper : function(cmp, ev) {
		var selectedList = cmp.get("v.selectedQuotes");
		var qIdList = [];
		for (var i = 0; i < selectedList.length; i++) {
			qIdList.push(selectedList[i].Id);
		}
		var myOppId = cmp.get("v.myOppId");
		var action = cmp.get("c.copyPartOfQuote");
		action.setParams({
			"originalQuoteIdList" : qIdList,
			"myOppId" : myOppId
		});
		action.setCallback(this, function(res) {
			var state = res.getState();
			if (state === "SUCCESS"){
				if (qIdList.length === 1) {
					location.href = "/lightning/r/Quote/"+res.getReturnValue()+"/view"
				} else {
					location.href = "/lightning/r/Opportunity/"+myOppId+"/view";
				}
			}else {
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
		if (selectedList.length > 0)
			$A.enqueueAction(action);
		else {
			var sp = cmp.find("mySpinner");
			$A.util.addClass(sp, "slds-hide");
			$A.util.removeClass(sp, "slds-show");
		}
	}
})

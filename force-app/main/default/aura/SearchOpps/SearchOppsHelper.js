({
	searchHelper : function(cmp, ev, kw) {
		var myId = cmp.get("v.myOppId");
		var action = cmp.get("c.fetchOpps");
		action.setParams({
			"keyword" : kw,
			"myOppId" : myId
		});
		action.setCallback(this, function(res){
			$A.util.removeClass(cmp.find("mySpinner"),"slds-show");
			var state = res.getState();
			if (state === "SUCCESS") {
				// res.getReturnValue().forEach(function(v){
				// 	v.CreatedDate = v.CreatedDate.left(10);
				// });
				cmp.set('v.listOfSearchRecords',res.getReturnValue());
				$A.util.addClass(cmp.find("mySpinner"), "slds-hide");
		    $A.util.removeClass(cmp.find("mySpinner"), "slds-show");
			}
			else if (state === "ERROR") {
				alert('error');
			}
		});
		$A.enqueueAction(action);
	}
})
({
	initHelper: function(c, columns) {
		console.log('helper');
		var action = c.get("c.doInit");
		action.setParams({
			"columns": columns,
		});
		action.setCallback(this, function(res) {
			var state = res.getState();
			if (state === "SUCCESS") {
				var info = [];
				res.getReturnValue().forEach(function(val) {
					console.log(JSON.parse(val));
					info.push(JSON.parse(val));
				});
				c.set("v.columns", info);
				console.log(c.get('v.columns'));
			}
			else {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
						title : 'Error Message',
						message:'コンポーネント初期化に失敗しました。見積項目の指定方法を確認してください。',
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
	},

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
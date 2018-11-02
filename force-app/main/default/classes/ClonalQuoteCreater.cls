public with sharing class ClonalQuoteCreater {
    /**
	*	クローン見積作成
	* @param オリジナル見積のID
	* @return クローン見積インスタンス
	*/
	public static Quote createClonalQuote(Id originalId) {

		String allFields = getAllFieldNames('Quote');
		String query = 'SELECT '+allFields+' FROM Quote WHERE Id = :originalId LIMIT 1';

		Quote originalQuote = Database.query(query);
		System.debug('original quote : '+ originalQuote);

		Quote clonalQuote = originalQuote.clone(false, true);
		System.debug('clonal quote : ' + clonalQuote);

		return clonalQuote;
	}

	/**
	*	クローン見積品目作成
	* @param originalId オリジナル見積のID
	*		 clonalQuoteId クローン見積のID
	* @return クローン見積品目リスト
	*/
	public static List<QuoteLineItem> createClonalQuoteItem(Id originalId, Id clonalQuoteId) {

		String allFields = getAllFieldNames('QuoteLineItem');
		String  query = 'SELECT '+allFields+' FROM QuoteLineItem WHERE QuoteId = :originalId';

		List<QuoteLineItem> originalItemList = Database.query(query);
		System.debug('original items :' + originalItemList);

		List<QuoteLineItem> clonalItemList = new List<QuoteLineItem>();
		for (QuoteLineItem item : originalItemList) {
			QuoteLineItem clonalItem = item.clone(false, true);
			clonalItem.QuoteId = clonalQuoteId;
			clonalItemList.add(clonalItem);
		}
		System.debug('clonal items :' + clonalItemList);

		return clonalItemList;
	}

	public static String getAllFieldNames(String sobjName){
		String strFieldKeys='';
		Schema.SObjectType sobjType = Schema.getGlobalDescribe().get(sobjName);
		Map<String, Schema.SObjectField> fmap = sobjType.getDescribe().fields.getMap();
		for (String fieldKey : fmap.keySet()) {
			Schema.SObjectField f = fmap.get(fieldKey);
			if(strFieldKeys == ''){
				strFieldKeys = fieldKey;
			}else{
				strFieldKeys +=  ',' + fieldKey;
			}
		}
		return strFieldKeys;
	}
}

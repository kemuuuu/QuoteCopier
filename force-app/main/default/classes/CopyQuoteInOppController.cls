public with sharing class CopyQuoteInOppController {

    /**
	*	案件内コピー
	*	@param コピー元となる見積のID
	*	@return コピーした見積のID
	*/
	@AuraEnabled
	public static Id copyQuote(Id originalId) {

		Quote clonalQuote = ClonalQuoteCreater.createClonalQuote(originalId);
		insert clonalQuote;

		List<QuoteLineItem> clonalItemList = ClonalQuoteCreater.createClonalQuoteItem(originalId, clonalQuote.Id);
		insert clonalItemList;

		return clonalQuote.Id;
	}

}

public with sharing class CopyQuoteCrossOverOppsController {
    /**
	* Componentから検索が実行されたときの処理
	* @param keyword Componentから受け取った検索ワード
    *        myOppId Component呼び出し元商談のID
	*/
	@AuraEnabled
	public static List<Opportunity> fetchOpps(String keyword, Id myOppId) {
		String query = 'SELECT Id, Name, Amount, Account.Name FROM Opportunity'
                     + ' WHERE ID != :myOppId AND Name LIKE \'%'+keyword+'%\' ORDER BY Name asc LIMIT 5';
		return Database.query(query);
	}

	/**
	* 見積部分コピー選択時に表示用見積取得
	* @param 選択された商談のID
	*/
	@AuraEnabled
	public static List<Quote> fetchQuotes(Id oppId) {
		return [SELECT Id, Subtotal, Name 
                FROM Quote 
                WHERE opportunityId = :oppId 
                ORDER BY CreatedDate desc];
	}

	/**
	* 検索した商談の全見積のコピー
	* @param targetOppId Componentで選択された商談のID
	*		 myOppId	 Component呼び出し元商談のID
	*/
	@AuraEnabled
	public static void copyAllQuote(Id targetOppId, Id myOppId) {

		String allFields = ClonalQuoteCreater.getAllFieldNames('Quote');
		String query = 'SELECT ' + allFields + ' FROM Quote '
					 + 'WHERE OpportunityId=\''+targetOppId+'\'';
		List<Quote> originalQuoteList = Database.query(query);

		Id clonalQId;
		for (Quote q : originalQuoteList) {
			clonalQId = createQuoteAndQuoteItem(q, myOppId);
		}
	}

	/**
	* コンポーネントで選択された見積のみをコピー
	* @param originalQuoteIdList 選択された見積のID
	*		 myOppId			 アクション呼び出し商談
	*/
	@AuraEnabled
	public static String copyPartOfQuote(List<Id> originalQuoteIdList, Id myOppId) {

		String allFields = ClonalQuoteCreater.getAllFieldNames('Quote');
		String query = 'SELECT ' + allFields + ' FROM Quote '
					 + 'WHERE Id IN :originalQuoteIdList';
		List<Quote> originalQuoteList = Database.query(query);

		Id clonalQId;
		for (Quote q : originalQuoteList) {
			 clonalQId = createQuoteAndQuoteItem(q, myOppId);
		}

		return clonalQId;
	}

	/**
	* 見積クローン、見積品目クローン作成
	* @param q オリジナル見積レコード
	*		 myOppId アクション呼び出し商談ID
	* @return 見積クローンのID
	*/
	private static Id createQuoteAndQuoteItem(Quote q, Id myOppId) {
		Quote clonalQuote = ClonalQuoteCreater.createClonalQuote(q.Id);
		clonalQuote.opportunityId = myOppId;
		insert clonalQuote;

        List<QuoteLineItem> clonalItemList = ClonalQuoteCreater.createClonalQuoteItem(q.Id, clonalQuote.Id);
		insert clonalItemList;

		return clonalQuote.Id;
	}
}

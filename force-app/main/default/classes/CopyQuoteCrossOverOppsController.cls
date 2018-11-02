public with sharing class CopyQuoteCrossOverOppsController {
	/**
	*	初期化
	*/
	@AuraEnabled
	public static List<string> doInit(List<String> columns){
		List<String> fields = new List<String>();
		Map<String, Schema.SObjectField> fldM = Schema.SObjectType.Quote.fields.getMap();
		for (String c : columns) {
			SFField f = new SFField();
			String l = fldM.get(c).getDescribe().getLabel();
			String t = String.valueOf(fldM.get(c).getDescribe().getType());
			f.label = l;
			f.type = t=='STRING'? 'text' : t.toLowerCase();
			f.fieldName = c;
			JSONGenerator g = JSON.createGenerator(false);
			g.writeObject(f);
			fields.add(g.getAsString());
		}
		return fields;
	}

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
		String allFields = ClonalQuoteCreater.getAllFieldNames('Quote');
		String q = 'SELECT ' + allFields + ' FROM Quote '
						 + 'WHERE opportunityId = :oppId ORDER BY CreatedDate desc';
		return Database.query(q);
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

	class SFField {
		String label;
		String fieldName;
		String type;
	}
}

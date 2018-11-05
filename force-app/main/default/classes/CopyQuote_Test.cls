@isTest(SeeAllData=true)
private class CopyQuote_Test {

	@isTest static void test_1() {
		Quote q = quoteGenerator();
		insert q;
		QuoteLineItem item = itemGenerator(q);
		insert item;
		Test.startTest();
		CopyQuoteInOppController.copyQuote(q.Id);
		Test.stopTest();
	}

	@isTest static void test_2() {
		Account a = new Account(Name='a**1');
		insert a;
		Opportunity o = new Opportunity(Name='beacon2^^',
                                        AccountId=a.Id,
                                        CloseDate=date.today(),
                                        StageName='新規ビジネス');
		insert o;
		Quote q = quoteGenerator();
		insert q;
		QuoteLineItem item = itemGenerator(q);
		insert item;

		Test.startTest();
        CopyQuoteCrossOverOppsController.doInit(new List<String>{'Name'});
		CopyQuoteCrossOverOppsController.fetchOpps('beacon',o.Id);
		CopyQuoteCrossOverOppsController.copyAllQuote(q.OpportunityId, o.Id);
		CopyQuoteCrossOverOppsController.fetchQuotes(o.Id);
		Test.stopTest();
	}

	@isTest static void test_3() {

		Account a = new Account(Name='a**1');
		insert a;

		Opportunity o = new Opportunity(Name='beacon2^^',
                                        AccountId=a.Id,
                                        CloseDate=date.today(),
                                        StageName='新規ビジネス');
		insert o;
		List<Id> quoteIds = new List<Id>();
		Quote q = quoteGenerator();
		insert q;

		QuoteLineItem item = itemGenerator(q);
		insert item;

		Quote q2 = quoteGenerator();
		insert q2;

		QuoteLineItem item2 = itemGenerator(q2);
		insert item2;

		quoteIds.add(q.Id);
		quoteIds.add(q2.Id);

		Test.startTest();
		CopyQuoteCrossOverOppsController.copyPartOfQuote(quoteIds, o.Id);
		Test.stopTest();
	}

	private static Quote quoteGenerator() {
		Account a = new Account(Name='Corp');
		insert a;
		Opportunity o = new Opportunity(Name='Greatest',
                                        AccountId=a.Id,
                                        CloseDate=date.today(),
                                        StageName='新規ビジネス');
		insert o;
		PriceBook2 stdpb = fetchStdPriceBook();
		Quote q = new Quote(Name='Quote',
                            OpportunityId=o.Id,
                            PriceBook2Id=stdpb.Id);
		return q;
	}

	private static QuoteLineItem itemGenerator(Quote q) {
		Product2 p = new Product2(Name='myPro');
		insert p;
		PriceBook2 pb = fetchStdPriceBook();
		PriceBookEntry pbe = new PriceBookEntry(UnitPrice=10000,
                                                PriceBook2Id=pb.Id,
                                                Product2Id=p.Id,
                                                isActive=true);
		insert pbe;
		QuoteLineItem item = new QuoteLineItem(Product2Id=p.Id,
                                                UnitPrice=10000,
                                                Quantity=1,
                                                QuoteId=q.Id,
                                                PriceBookEntryId=pbe.Id);
		return item;
	}

	private static PriceBook2 fetchStdPriceBook() {
		return [SELECT Id FROM PriceBook2 WHERE IsStandard = true limit 1];
	}

}
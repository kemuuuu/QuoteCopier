({
    init : function(c, e, h) {
        
        var sp = c.find("mySpinner");
        $A.util.addClass(sp, "slds-show");
        $A.util.removeClass(sp, "slds-hide");

        h.callClone(c);
	}
})

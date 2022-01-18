/**
 * Created by DAEU on 2022-01-14.
 */

trigger OpportunityToOrder_tr on Opportunity (after update, after insert, before update) {
    for(Opportunity opp : Trigger.new){
        if(Trigger.isBefore){
            // 승인되지 않은 Closed Won이면 에러 메세지 발생
            if(!opp.IsApproved__c && opp.StageName == 'Closed Won'){
                opp.addError('IsApproved is False');
            }
        }
        if(Trigger.isAfter){
            if(opp.IsApproved__c && opp.StageName == 'Closed Won'){
                // Opportunity에 대한 Contract 생성
                Contract contract = new Contract();
                contract.AccountId = opp.AccountId;
                contract.Status = 'Draft';
                contract.StartDate = Date.today();
                contract.ContractTerm = 1;

                insert contract;

                // Contract에 대한 Order 생성
                Order order = new Order();
                order.AccountId = opp.AccountId;
                order.EffectiveDate = Date.today();
                order.ContractId = contract.Id;
                order.Status = 'Draft';
                order.Pricebook2Id = opp.Pricebook2Id;

                insert order;

                // 주문제품과 자산 생성
                List<OrderItem> listOrderItems = new List<OrderItem>();
                List<Asset> listAsset = new List<Asset>();
                for(OpportunityLineItem opportunityLineItem : [SELECT Id, Name, ProductCode, Quantity, ProductType__c, UnitPrice, OpportunityId,
                        TotalPrice, ListPrice, Description, Product2Id, PricebookEntryId FROM OpportunityLineItem WHERE OpportunityId =: opp.Id]) {
                   System.debug('oppItem Id : ' + opportunityLineItem.Id);
                    // Software는 주문제품으로 등록하지 않음
                    if (opportunityLineItem.ProductType__c == 'Hardware') {
                        OrderItem orderItem = new OrderItem();
                        orderItem.OrderId = order.Id;
                        orderItem.ListPrice = opportunityLineItem.ListPrice;
                        orderItem.UnitPrice = opportunityLineItem.UnitPrice;
                        orderItem.Quantity = opportunityLineItem.Quantity;
                        orderItem.ProductType__c = opportunityLineItem.ProductType__c;
                        orderItem.Description = opportunityLineItem.Description;
                        orderItem.PricebookEntryId = opportunityLineItem.PricebookEntryId;
                        orderItem.Product2Id = opportunityLineItem.Product2Id;

                        listOrderItems.add(orderItem);
                    }

                    // asset 생성
                    Asset asset = new Asset();
                    asset.AccountId = order.AccountId;
                    asset.Product2Id = opportunityLineItem.Product2Id;
                    asset.Quantity = opportunityLineItem.Quantity;
                    asset.Price = opportunityLineItem.UnitPrice;
                    asset.SerialNumber = Datetime.now() + '_' + opportunityLineItem.Id;
                    asset.Name = opportunityLineItem.Name;

                    if(opportunityLineItem.ProductType__c == 'Hardware'){
                        asset.Name += '_Hardware';
                        asset.Status = 'Purchased';
                    }else{
                        asset.Name += '_Software';
                        asset.Status = 'Registered';
                    }

                    listAsset.add(asset);
                }

                // Software일 때는 orderItem이 생성되진 않기 때문에 개별로 조건문 생성
                if(!listOrderItems.isEmpty()){
                    insert listOrderItems;
                }
                if(!listAsset.isEmpty()){
                    insert listAsset;
                }
            }
        }
    }
}
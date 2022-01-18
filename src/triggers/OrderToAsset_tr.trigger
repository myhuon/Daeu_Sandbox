/**
 * Created by DAEU on 2022-01-16.
 */

trigger OrderToAsset_tr on Order (before update) {

    if(Trigger.isUpdate){
        Set<Id> orderIdSet = new Set<Id>();
        List<Asset> listAsset = new List<Asset>();

        System.debug('Order Trigger Update Check');

        for(Order order : Trigger.new){
            orderIdSet.add(order.Id);
            System.debug('Order Id : ' + order.Id);

            if(order.Status == 'Activated' && order.Status != Trigger.oldMap.get(order.Id).Status){
                System.debug('Staus Activated');

                for(Asset asset : [SELECT Status, Product2Id, Id, AccountId, OwnerId, SerialNumber, Name, Quantity, Price  FROM Asset
                    WHERE Product2Id IN (SELECT Product2Id FROM OrderItem WHERE OrderId =: order.Id)]){

                    asset.Status = 'Shipped';
                    listAsset.add(asset);
                }
            }
        }
        if(listAsset.size() > 0){
            System.debug('before update');
            for(Asset a : listAsset){
                System.debug(a);
            }
            update listAsset;
        }
    }
}
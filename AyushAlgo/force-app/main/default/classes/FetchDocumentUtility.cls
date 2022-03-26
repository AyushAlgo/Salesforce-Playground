/**
 * 
 * @Author : Ayush Mishra
 * @Email : ayushm3204@gmail.com
 * 
 **/
public without sharing class FetchDocumentUtility {
    public static Map<Id, List<String>> linkedEntityIdToUrlsMap = new Map<Id,List<String>>();
    public static Map<Id, List<Blob>> linkedEntityIdToBlobsMap = new Map<Id, List<Blob>>();
    public static void getDocumentsInfo(Set<Id> sObjectIdSet, Boolean latest, String filter) {
        try {
            Map<Id, Set<Id>> linkedEntityIdToDocIdSetMap = new Map<Id, Set<Id>>();
            Set<Id> docIdSet;
            Set<Id> finalDocIdSet = new Set<Id>();
            String myQuery = 'SELECT ContentDocumentId, LinkedEntityId, ContentDocument.CreatedDate, ContentDocument.Title ' + 
                    'FROM ContentDocumentLink WHERE LinkedEntityId IN:sObjectIdSet';
            if(String.isNotBlank(filter)) {
                myQuery += ' AND '+ filter;     
            }
            List<ContentDocumentLink> resultList = Database.query(myQuery);
            for(ContentDocumentLink docLink : resultList) {
                    if(linkedEntityIdToDocIdSetMap.containskey(docLink.LinkedEntityId)) {
                        docIdSet = linkedEntityIdToDocIdSetMap.get(docLink.LinkedEntityId);
                    } else {
                        docIdSet = new Set<Id>();
                    }
                    docIdSet.add(docLink.ContentDocumentId);
                    finalDocIdSet.add(docLink.ContentDocumentId);                                   
                    linkedEntityIdToDocIdSetMap.put(docLink.LinkedEntityId, docIdSet);                                       
            }
            Map<Id, ContentVersion> docIdToContentVerMap = new Map<Id, ContentVersion>();
            Map<Id, Blob> docIdToVersionDataMap = new Map<Id, Blob>();
            for(ContentVersion ver : [SELECT VersionData, ContentDocumentid, CreatedDate, PathOnClient
                                      FROM ContentVersion 
                                      WHERE ContentDocumentid IN:finalDocIdSet]) {
                                          docIdToContentVerMap.put(ver.ContentDocumentid, ver);
                                          docIdToVersionDataMap.put(ver.ContentDocumentid, ver.VersionData);
                                      }
            List<ContentDistribution> conDistList = new List<ContentDistribution>();
            conDistList	= [SELECT ContentDocumentId, ContentDownloadUrl, ContentVersionId FROM ContentDistribution 
                           WHERE ContentDocumentId IN: finalDocIdSet];
            if(conDistList.size() == 0) {
                for(Id docid : docIdToContentVerMap.keySet()) {
                    ContentDistribution cdist = new ContentDistribution();
                    cdist.Name				 = docIdToContentVerMap.get(docid).PathOnClient;
                    cdist.ContentVersionId   = docIdToContentVerMap.get(docid).Id;
                    cdist.PreferencesAllowViewInBrowser = true;
                    cdist.PreferencesNotifyOnVisit		= false;
                    conDistList.add(cdist);
                }
                if(conDistList.size() > 0) {
                    insert conDistList;
                }    
            }
            Map<Id, String> veridToUrlMap = new Map<id, String>();
            Map<Id, String> docIdToUrlMap = new Map<id, String>();
            for(ContentDistribution dist : conDistList) {
                veridToUrlMap.put(dist.ContentVersionId, dist.ContentDownloadUrl);
                docIdToUrlMap.put(dist.ContentDocumentId, dist.ContentDownloadUrl);
            }
            if(latest) {
                Map<id, ContentVersion> linkedEntityIdToLatestConVerMap = new Map<id, ContentVersion>();
                for(Id linkedEntityId : linkedEntityIdToDocIdSetMap.keySet()) {
                    for(Id docId : linkedEntityIdToDocIdSetMap.get(linkedEntityId)) {
                        if(!linkedEntityIdToLatestConVerMap.containskey(linkedEntityId) 
                        || (docIdToContentVerMap.get(docId).CreatedDate > linkedEntityIdToLatestConVerMap.get(linkedEntityId).CreatedDate)) {
                            linkedEntityIdToLatestConVerMap.put(linkedEntityId, docIdToContentVerMap.get(docId));      
                        }      
                    }
                }
                for(Id linkedEntityId : linkedEntityIdToLatestConVerMap.keySet()) {
                    linkedEntityIdToUrlsMap.put(linkedEntityId, veridToUrlMap.get(linkedEntityIdToLatestConVerMap.get(linkedEntityId).Id).split(' '));
                    List<Blob> blobList = new List<Blob>();
                    blobList.add(docIdToVersionDataMap.get(linkedEntityIdToLatestConVerMap.get(linkedEntityId).ContentDocumentId));
                    linkedEntityIdToBlobsMap.put(linkedEntityId, blobList);
                }
            } else {
                List<String> urls;
                List<Blob> blobList;
                for(Id linkedEntityId : linkedEntityIdToDocIdSetMap.keySet()) {
                    for(Id docId : linkedEntityIdToDocIdSetMap.get(linkedEntityId)) {
                        if(!linkedEntityIdToUrlsMap.containsKey(linkedEntityId)) {
                            urls = new list<String>();
                            blobList = new List<Blob>();
                        } else {
                            urls = linkedEntityIdToUrlsMap.get(linkedEntityId);
                            blobList = linkedEntityIdToBlobsMap.get(linkedEntityId);
                        }
                        urls.add(docIdToUrlMap.get(docId));
                        linkedEntityIdToUrlsMap.put(linkedEntityId, urls);
                        blobList.add(docIdToVersionDataMap.get(docId));
                        linkedEntityIdToBlobsMap.put(linkedEntityId, blobList);
                    }
                }
            }
        } catch (exception e) {
            System.debug('[Exception] ' + e.getMessage());
        }
    }
}
/**
 * Invoking Sample:
 * */
/*
    Set<Id> sObjectIdSet = new Set<id>();
    sObjectIdSet.add(''); // place any Valid LinkedEntity 18 digit Id [Obj to which docs are attached/linked]
    sObjectIdSet.add(''); // place any Valid LinkedEntity 18 digit Id [Obj to which docs are attached/linked]
    String filter = 'ContentDocument.Title LIKE \'%TEST%\''; // any SOQL Condition after AND
    //String filter = 'ContentDocument.Title LIKE \'%TEST%\''; // Make sure to query the field on which filter is applied
    //String filter = ''; // when no filter required
    FetchDocumentUtility.getDocumentsInfo(sObjectIdSet, true, filter); // for latest, put true else false[will fetch all].
    
    for(Id lid : FetchDocumentUtility.linkedEntityIdToUrlsMap.keySet()) {
        for(String url : FetchDocumentUtility.linkedEntityIdToUrlsMap.get(lid)) {
            System.debug(lid + '=>' + url);    
        }
    }
    System.debug('-------------');
    for(Id lid : FetchDocumentUtility.linkedEntityIdToBlobsMap.keySet()) {
        for(Blob blobValue : FetchDocumentUtility.linkedEntityIdToBlobsMap.get(lid)) {
            System.debug(lid + '=>' + blobValue);
        }
    }
*/
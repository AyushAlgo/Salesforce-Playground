import { LightningElement, track } from 'lwc';
import getContacts from '@salesforce/apex/TableHandler.getContacts';

export default class ParentTable extends LightningElement {
    @track records = [];
    @track dataLoaded = false;
    get actions() {
        return [
            {actionlabel : 'Delete', actionHandler : 'firedelete'},
            {actionlabel : 'Update', actionHandler : 'fireupdate'},
        ]
    }
    get columns() {
        return [
            {label: 'First Name', matchingFieldApi: 'FirstName'},
            {label: 'Last Name', matchingFieldApi: 'LastName'},
            {label: 'Birth Date',  matchingFieldApi: 'Birthdate'},
            {label: 'Account Name', matchingFieldApi: 'Account.Name'},
            {label: 'Action', matchingFieldApi: 'Action'},
        ];
    }
    connectedCallback() {
        this.loadData();
    }

    handledelete(event) {
        console.log(event.detail.handlerName);
        console.log(event.detail.recordId);
    }

    handleupdate(event) {
        console.log(event.detail.handlerName);
        console.log(event.detail.recordId);
    }

    loadData() {
        getContacts()
        .then(res => {
            this.records = res;
            this.dataLoaded = true;
        }).catch(err => console.log(err));
    }
}
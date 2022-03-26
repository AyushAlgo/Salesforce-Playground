import { LightningElement, track } from 'lwc';
import getContact from '@salesforce/apex/ManageContactHandler.getContact';
import upsertContact from '@salesforce/apex/ManageContactHandler.upsertContact';

export default class ManageContact extends LightningElement {
    @track contactId;
    @track data = {};
    connectedCallback() {
        const urlParams = new URLSearchParams(window.location.search);
        if(urlParams.get('contactId')) {
            console.log(urlParams.get('contactId'));
            this.contactId = urlParams.get('contactId');
            this.getContact();
        } else {
            this.data = {
                'FirstName' : '',
                'LastName' : '',
                'Birthdate' : ''
            }
        }
    }
    getContact(){
        getContact({
            conId : this.contactId
        }).then(res => {
            this.data = res;
            this.data = this.data[0];
        }).catch(err => {
            console.log(err);
        })
    }

    handleChange(event) {
        let eventName = event.target.dataset.name;
        this.data[eventName] = event.target.value;
    }

    handleClick(event) {
        console.log(JSON.stringify(this.data, undefined, 2));
        upsertContact({
            conDetails : JSON.stringify(this.data)
        }).then(res => {
            console.log(res);
        }).catch(err => {
            console.log(err);
        })
    }
}
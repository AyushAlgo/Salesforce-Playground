import { LightningElement, track } from 'lwc';
import insertContact from '@salesforce/apex/ContactInsertHandler.insertContact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class ContactInsert extends LightningElement {
    @track nameValue1;
    @track nameValue2;
    @track nameValue3;
    @track nameValue4;
    handleFname = (event) => {
        this.nameValue1 = event.target.value;
    }
    handleLname = (event) => {
        this.nameValue2 = event.target.value;
    }
    handlePhone = (event) => {
        this.nameValue3 = event.target.value;
    }
    handleBirthDate(event) {
        this.nameValue4 = event.target.value;
    }
    handleClick() {
        console.log('clicked');
        insertContact({
            lastName: this.nameValue2,
            firstName: this.nameValue1,
            phone: this.nameValue3,
            birthdate: this.birthdate
        }).then(res => {
            console.log(res);
        }).catch(e => {
            console.log(e);
            if(e.body != undefined && e.body.message != undefined && e.body.message.includes("**Duplicate Contact Found**")) {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error Inserting Contact',
                    message: "Duplicate Contact Found",
                    variant: 'error'
                }));
            } else {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Get Help',
                    message: e.body.message,
                    variant: 'error'
                }));
            }
        })
    }
    handlePrint() {
        let divElementHTML = this.template.querySelector('[data-id="printablDiv"]').innerHTML;;
        let doc = window.open('', '', 'height=500, width=500');
        console.log(divElementHTML);
        doc.document.write('<html>');
        doc.document.write('<body > <h1>Div contents are <br>');
        doc.document.write(divElementHTML);
        doc.document.write('</body></html>');
        doc.document.close();
        doc.print();
    }
}
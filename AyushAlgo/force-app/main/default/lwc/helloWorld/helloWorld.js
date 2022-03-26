import { LightningElement, track } from 'lwc';

export default class HelloWorld extends LightningElement {
    @track greetPlaceholder;
    constructor() {
        super();
        this.greetPlaceholder = 'Hello Default';
    }
    handleChange = (event) => {
        if(event.target.value == '') {
            this.greetPlaceholder = 'Hello Default';
        } else {
            this.greetPlaceholder = 'Hello ' + event.target.value;
        }
    }
}
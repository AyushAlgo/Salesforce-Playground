import { LightningElement, track } from 'lwc';

export default class TableHeader extends LightningElement {
    @track permitChunk;
    @track pageNumber;
    @track totalRecords;
    @track totalPages;
    @track previousDisabled;
    @track nextDisabled;
    @track actionVisible = false;

    get permit() {
        return [
            {
                application_number : 'a00190000077TGL',
                application_type : 'Permit Application',
                permit_number : 'P-000001',
                permit_type: 'Factory Built Building Installation Permit',
                application_status : 'Approved',
                action: 'view pay'    
            },
            {
                application_number : 'a00190000077TGL',
                application_type : 'Permit Application',
                permit_number : 'P-000002',
                permit_type: 'Factory Built Building Installation Permit',
                application_status : 'Approved',
                action: 'view pay'    
            },
            {
                application_number : 'a00190000077TGL',
                application_type : 'Permit Application',
                permit_number : 'P-000003',
                permit_type: 'Factory Built Building Installation Permit',
                application_status : 'Approved',
                action: 'view pay'    
            },
            {
                application_number : 'a00190000077TGL',
                application_type : 'Permit Application',
                permit_number : 'P-000004',
                permit_type: 'Factory Built Building Installation Permit',
                application_status : 'Approved',
                action: 'view pay'    
            },
            {
                application_number : 'a00190000077TGL',
                application_type : 'Permit Application',
                permit_number : 'P-000005',
                permit_type: 'Factory Built Building Installation Permit',
                application_status : 'Approved',
                action: 'view pay'    
            },
            {
                application_number : 'a00190000077TGL',
                application_type : 'Permit Application',
                permit_number : 'P-000006',
                permit_type: 'Factory Built Building Installation Permit',
                application_status : 'Approved',
                action: 'view pay'    
            },
            {
                application_number : 'a00190000077TGL',
                application_type : 'Permit Application',
                permit_number : 'P-000007',
                permit_type: 'Factory Built Building Installation Permit',
                application_status : 'Approved',
                action: 'view pay'    
            }
        ];
    }
    connectedCallback() {
        this.pageNumber = 1;
        this.setChunks();
    }

    showActions() {
        this.actionVisible = !this.actionVisible;
    }

    setChunks() {
        this.totalRecords = this.permit.length;
        this.totalPages = Math.ceil(this.totalRecords / 2);
        let begin = (this.pageNumber - 1) * 2;
        let end = begin + 2;
        this.permitChunk = this.permit.slice(begin, end);
        this.previousDisabled = (this.pageNumber === 1) ? true : false; 
        this.nextDisabled = (this.pageNumber === this.totalPages) ? true : false; 
    }
    handleClick(e) {
        if(e.target.dataset.label === 'Previous') {
            if(this.pageNumber-1 > 0) {
                this.pageNumber--;
                this.setChunks();
            }
        }
        if(e.target.dataset.label === 'Next') {
            if(this.pageNumber < this.totalPages) {
                this.pageNumber++;
                this.setChunks();
            }
        }
    }
}
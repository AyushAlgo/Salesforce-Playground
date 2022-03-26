import { LightningElement, track, api } from 'lwc';

export default class ChildTable extends LightningElement {
    @api records;
    @api columns;
    @api recordKey;
    @api actions;

    @track parsedRecords = [];
    @track parsedColumns = [];
    @track actionVisible = false;

    globalKey = -1;
    get indexKey() {
        this.globalKey += 1;
        return this.globalKey;
    }

    connectedCallback() {
        if(this.records && this.columns) {
            this.prepareColumns();
            this.prepareRecords();
        }
    }

    prepareColumns() {
        this.columns.forEach(column => {
            let columnObj = {};
            columnObj['label'] = column.label;
            columnObj.key = column['matchingFieldApi'];
            this.parsedColumns.push(columnObj);
        })
        //console.log(JSON.stringify(this.parsedColumns, undefined, 2));
    }

    calculateValue(api, record) {
        let apis = api.split('.');
        let value = '';
        let counter = 0;
        apis.forEach(fieldApi => {
            if(record[fieldApi] != undefined) {
                value = record[fieldApi];
                record = record[fieldApi];
                counter++;
            }
        })
        value = (counter == apis.length) ? value : '';
        return value;
    }

    prepareRecords() {
        this.records.forEach(record => {
            let recordObj = {};
            let recordValues = [];
            this.parsedColumns.forEach(column => {
                if(column.key.includes('.')) {
                    recordValues.push(this.calculateValue(column.key, record));
                }else if(column.key != 'Action') {
                    recordValues.push(record[column.key]);
                }
            })
            recordObj['key'] = record[this.recordKey];
            recordObj['values'] = recordValues;
            this.parsedRecords.push(recordObj);
        })
        //console.log(JSON.stringify(this.parsedRecords, undefined, 2));
    } 

    handleAction(event) {
        let handlerName = event.target.value;
        let recordId = event.target.dataset.recdid;
        let param = {
            handlerName,
            recordId,
        }
        this.dispatchEvent(new CustomEvent(handlerName, {
            detail: param
        }));
        // console.log(handlerName, recordId);
    }

    showActions() {
        this.actionVisible = !this.actionVisible;
    }
}
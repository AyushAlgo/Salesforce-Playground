import { LightningElement, track } from 'lwc';

export default class DataTableFilters extends LightningElement {
    @track age='';
    @track nameSearch='';
    @track filteredData;
    get data() {
        return [
            {firstName : 'Ayush', lastName : 'Mishra', age : '22'},
            {firstName : 'Akash', lastName : 'Verma', age : '25'},
            {firstName : 'Baldev', lastName : 'Prayg', age : '21'},
            {firstName : 'Bala', lastName : 'Goyal', age : '26'},
            {firstName : 'Chamunda', lastName : 'Batra', age : '22'},
            {firstName : 'Chirag', lastName : 'Khandelwal', age : '27'},
            {firstName : 'Zeshan', lastName : 'Milaf', age : '25'},
            {firstName : 'Zayn', lastName : 'Ashfaq', age : '25'},
            {firstName : 'Viki', lastName : 'kaushal', age : '23'},
            {firstName : 'George', lastName : 'Washington', age : '24'},
            {firstName : 'Jaynth', lastName : 'B', age : '29'},
            {firstName : 'Jignesh', lastName : 'R', age : '21'},
            {firstName : 'Gignesh', lastName : 'Allowalia', age : '28'},
            {firstName : 'Mahanto', lastName : 'Maharishi', age : '20'},
        ]
    }

    get ageOptions() {
        return [
            {label: '20', value: '20'},
            {label: '21', value: '21'},
            {label: '22', value: '22'},
            {label: '23', value: '23'},
            {label: '24', value: '24'},
            {label: '25', value: '25'},
            {label: '26', value: '26'},
            {label: '27', value: '27'},
            {label: '28', value: '28'},
            {label: '29', value: '29'},
            {label: '30', value: '30'},
            {label: '31', value: '31'},
            {label: 'None', value: ''},
        ];
    }

    connectedCallback() {
        this.filteredData = this.data;
        this.nameSearch = '';
        this.age = '';
    }

    handleFilter(event) {
        let eventName = event.target.dataset.name;
        let eventValue = event.target.value;
        if(eventName === 'agefilter') {
            this.age = eventValue;
        } else if(eventName === 'namefilter') {
            this.nameSearch = eventValue;
        }
        this.filteredData = this.data.filter(row => {
            let currentRowAge = row.age.toLowerCase();
            let currentRowFirstName = row.firstName.toLowerCase();
            return (currentRowAge.includes(this.age) && currentRowFirstName.includes(this.nameSearch));
        });
    }
}
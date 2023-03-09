import { LightningElement, wire } from 'lwc';

import LWCNextHolidayTitle from '@salesforce/label/c.LWCNextHolidayTitle';

import NATIONAL_HOLIDAYS_NAME_FIELD from '@salesforce/schema/National_Holidays__c.Name';
import NATIONAL_HOLIDAYS_DATE_FIELD from '@salesforce/schema/National_Holidays__c.Date__c';

import { getSObjectValue } from '@salesforce/apex';
import getNextHoliday from '@salesforce/apex/NextHolidayController.getNextHoliday';

export default class NextHoliday extends LightningElement {
    holiday;

    label = {
        LWCNextHolidayTitle
    };

    @wire(getNextHoliday)
    getNextHoliday(result) {
        this.holiday = result?.data;
    }

    get hasNextHoliday() {
        return Boolean(this.holiday);
    }

    get getName() {
        return this.getValueFromField(this.holiday, NATIONAL_HOLIDAYS_NAME_FIELD);
    }

    get getDate() {
        return this.getValueFromField(this.holiday, NATIONAL_HOLIDAYS_DATE_FIELD);
    }

    get getDaysUntilNextHoliday() {
        let diffDays = 0;
        let dateVar = this.getValueFromField(this.holiday, NATIONAL_HOLIDAYS_DATE_FIELD);
        if (dateVar) {
            let holidayDate = this.convertToUTC(new Date(dateVar));
            let today = this.convertToUTC(new Date());

            const diffTime = Math.abs(holidayDate - today);
            diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        }
        return diffDays;
    }

    get isToday() {
        let dateVar = new Date(this.getValueFromField(this.holiday, NATIONAL_HOLIDAYS_DATE_FIELD));
        let today = new Date();
        return this.hasNextHoliday &
            today.getUTCFullYear() == dateVar?.getUTCFullYear() &&
            today.getUTCMonth() == dateVar?.getUTCMonth() &&
            today.getUTCDay() == dateVar?.getUTCDay();
    }

    convertToUTC(someDate) {
        let someDateStr =
            `${someDate.getUTCFullYear()}-${someDate.getUTCMonth() < 10 ? '0' + someDate.getUTCMonth() : someDate.getUTCMonth()}-${someDate.getUTCDay() < 10 ? '0' + someDate.getUTCDay() : someDate.getUTCDay()}`;
        someDate = new Date(someDateStr);
        return someDate;
    }

    getValueFromField = (record, field) => {
        return record ? getSObjectValue(record, field) : undefined;
    }
}
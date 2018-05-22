format
	id email
	value [A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}
format
	id telephone
	value (\+\d{2}\s*(\(\d{2}\))|(\(\d{2}\)))?\s*\d{4,5}\-?\d{4}
format
	id date
	value \b(?:20)?(\d\d)[-./](0?[1-9]|1[0-2])[-./](3[0-1]|[1-2][0-9]|0?[1-9])\b
format
    id date-display
    value yyyy-MM-dd
format
    id time-display
    value hh:mm:ss a
format
    id date-time-display
    value yyyy-MM-dd hh:mm:ss a
option-set
	id MyCountry
	option
		id CA
		value Canada
	option
		id ES
		value Spain
	option
		id OT
		value Other
	option
		id US
		value United States
option-set
	id State
	option
		id AL
		value Alabama
	option
		id AK
		value Alaska
	option
		id AZ
		value Arizona	
	option
		id AR
		value Arkansas 

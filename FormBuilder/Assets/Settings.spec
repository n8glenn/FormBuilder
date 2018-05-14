format
	id email
	value [A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}
format
	id telephone
	value (\+\d{2}\s*(\(\d{2}\))|(\(\d{2}\)))?\s*\d{4,5}\-?\d{4}
format
	id date
	value \b(?:20)?(\d\d)[-./](0?[1-9]|1[0-2])[-./](3[0-1]|[1-2][0-9]|0?[1-9])\b
option-set
	id Country
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
	option
		id CA
		value Califormia
	option
		id CO
		value Colorado
	option
		id CT
		value Connecticut
	option
		id DE
		value Delaware
	option
		id FL
		value Florida
	option
		id GA
		value Georgia
	option
		id HI
		value Hawaii
	option
		id ID
		value Idaho
	option
		id IL
		value Illinois
	option
		id IN
		value Indiana
	option
		id IA
		value Iowa
	option
		id KS
		value Kansas
	option
		id KY
		value Kentucky
	option
		id LA
		value Louisiana
	option
		id Maine
		value ME
	option
		id MD
		value Maryland
	option
		id MA
		value Massachusetts
	option
		id MI
		value Michigan
	option
		id MN
		value Minnesota
	option
		id MS
		value Mississippi
	option
		id MO
		value Missouri
	option
		id MT
		value Montana
	option
		id NE
		value Nebraska
	option
		id NV
		value Nevada
	option
		id NH
		value New Hampshire
	option
		id NJ
		value New Jersey
	option
		id NM
		value New Mexico
	option
		id NY
		value New York
	option
		id NC
		value North Carolina
	option
		id ND
		value North Dakota
	option
		id OH
		value Ohio
	option
		id OK
		value Oklahoma
	option
		id OR
		value Oregon
	option
		id PA
		value Pennsylvania
	option
		id RI
		value Rhode Island
	option
		id SC
		value South Carolina
	option
		id SD
		value South Dakota
	option
		id TN
		value Tennessee
	option
		id TX
		value Texas
	option
		id UT
		value Utah
	option
		id VT
		value Vermont
	option
		id VA
		value Virginia
	option
		id WA
		value Washington
	option
		id WV
		value West Virginia
	option
		id WI
		value Wisconsin
	option
		id WY
		value Wyoming
option-set
	id Delivery
	option
		id USPS
		value Express Mail
	option
		id UPS
		value UPS
	option
		id FEDEX
		value Fed Ex

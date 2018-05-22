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
	id Country
	option
		id AF
		value Afghanistan
	option
		id AX
		value Aland Islands
	option
		id AL
		value Albania
	option
		id DZ
		value Algeria
	option
		id AS
		value American Samoa
	option
		id AD
		value Andorra
	option
		id AO
		value Angola
	option
		id AI
		value Anguilla
	option
		id AQ
		value Antarctica
	option
		id AG
		value Antigua and Barbuda
	option
		id AR
		value Argentina
	option
		id AM
		value Armenia
	option
		id AW
		value Aruba
	option
		id AU
		value Australia
	option
		id AT
		value Austria
	option
		id AZ
		value Azerbaijan
	option
		id BS
		value Bahamas, The
	option
		id BH
		value Bahrain
	option
		id BD
		value Bangladesh
	option
		id BB
		value Barbados
	option
		id BY
		value Belarus
	option
		id BE
		value Belgium
	option
		id BZ
		value Belize
	option
		id BJ
		value Benin
	option
		id BM
		value Bermuda
	option
		id BT
		value Bhutan
	option
		id BO
		value Bolivia
	option
		id BQ
		value Bonaire, St. Eustat, Saba
	option
		id BA
		value Bosnia and Herzegovina
	option
		id BW
		value Botswanaa
	option
		id BV
		value Bouvet Island
	option
		id BR
		value Brazil
	option
		id IO
		value British Indian Ocean Territories
	option
		id VG
		value British Virgin Islands
	option
		id BN
		value Brunei Darussalam
	option
		id BG
		value Bulgaria
	option
		id BF
		value Burkina Faso
	option
		id BI
		value Burundi
	option
		id CV
		value Cabo Verde
	option
		id KH
		value Cambodia
	option
		id CM
		value Cameroon
	option
		id CA
		value Canada
	option
		id KY
		value Cayman Islands
	option
		id CF
		value Central African Republic
	option
		id TD
		value Chad
	option
		id CL
		value Chile
	option
		id CN
		value China
	option
		id CX
		value Christmas Island
	option
		id CC
		value Cocos (Keeling) Islands
	option
		id CO
		value Columbia
	option
		id KM
		value Comoros
	option
		id CG
		value Congo
	option
		id CD
		value Congo, Democratic Republic of the
	option
		id CK
		value Cooke Islands
	option
		id CR
		value Costa Rica
	option
		id CI
		value Cote D'Ivoire
	option
		id HR
		value Croatia
	option
		id CU
		value Cuba
	option
		id CW
		value Curacao
	option
		id CY
		value Cyprus
	option
		id CZ
		value Czech Republic
	option
		id DK
		value Denmark
	option
		id DJ
		value Djibouti
	option
		id DM
		value Dominica
	option
		id DO
		value Dominican Republic
	option
		id TP
		value East Timor (Timor-Leste)
	option
		id EC
		value Ecuador
	option
		id EG
		value Egypt
	option
		id SV
		value El Salvador
	option
		id GQ
		value Equatorial Guinea
	option
		id ER
		value Eritrea
	option
		id EE
		value Estonia
	option
		id ET
		value Ethiopia
	option
		id EU
		value European Union
	option
		id FK
		value Falkland Islands (Malvinas)
	option
		id FO
		value Faroe Islands
	option
		id FJ
		value Fiji
	option
		id FI
		value Finland
	option
		id FR
		value France
	option
		id GF
		value French Guiana
	option
		id PF
		value French Polynesia
	option
		id TF
		value French Southern Territories
	option
		id GA
		value Gabon
	option
		id GM
		value Gambia, the
	option
		id GE
		value Georgia
	option
		id DE
		value Germany
	option
		id GH
		value Ghana
	option
		id GI
		value Gibraltar
	option
		id GR
		value Greece
	option
		id GL
		value Greenland
	option
		id GD
		value Grenada
	option
		id GP
		value Guadeloupe
	option
		id GU
		value Guam
	option
		id GT
		value Guatemala
	option
		id GG
		value Guernsey and Alderney
	option
		id GF
		value Guiana, French
	option
		id GN
		value Guinea
	option
		id GW
		value Guinea-Bissau
	option
		id GP
		value Guinea, Equatorial
	option
		id GY
		value Guyana
	option
		id HT
		value Haiti
	option
		id HM
		value Heard and McDonald Islands
	option
		id VA
		value Holy City (Vatican)
	option
		id HN
		value Honduras
	option
		id HK
		value Hong Kong (China)
	option
		id HU
		value Hungary
	option
		id IS
		value Iceland
	option
		id IN
		value India
	option
		id ID
		value Indonesia
	option
		id IR
		value Iran, Islamic Republic of
	option
		id IQ
		value Iraq
	option
		id IE
		value Ireland
	option
		id IL
		value Israel
	option
		id IT
		value Italy
	option
		id CI
		value Ivory Coast (Cote d'Ivoire)
	option
		id JM
		value Jamaica
	option
		id JP
		value Japan
	option
		id JE
		value Jersey
	option
		id JO
		value Jordan
	option
		id KZ
		value Kazakhstan
	option
		id KE
		value Kenya
	option
		id KI
		value Kiribati
	option
		id KP
		value Korea, Democratic People's Republic of
	option
		id KR
		value Korea (South) Republic of
	option
		id KV
		value Kosovo
	option
		id KW
		value Kuwait
	option
		id KG
		value Kyrgyzstan
	option
		id LA
		value Lao People's Democratic Republic
	option
		id LV
		value Latvia
	option
		id LB
		value Lebanon
	option
		id LS
		value Lesotho
	option
		id LR
		value Liberia
	option
		id LY
		value Libyan Arab Jamahiriya
	option
		id LI
		value Liechtenstein
	option
		id LT
		value Lithuania
	option
		id LU
		value Luxembourg
	option
		id MO
		value Macao (China)
	option
		id MK
		value Macedonia, TFYR
	option
		id MG
		value Madagascar
	option
		id MW
		value Malawi
	option
		id MY
		value Malaysia
	option
		id MV
		value Maldives
	option
		id ML
		value Mali
	option
		id MT
		value Malta
	option
		id IM
		value Man, Isle of
	option
		id MH
		value Marshall Islands
	option
		id MQ
		value Martinique (FR)
	option
		id MR
		value Mauritania
	option
		id MU
		value Mauritius
	option
		id YT
		value Mayotte (FR)
	option
		id MX
		value Mexico
	option
		id FM
		value Micronesia, Federated States of
	option
		id MD
		value Moldova, Republic of
	option
		id MC
		value Monaco
	option
		id MN
		value Mongolia
	option
		id CS
		value Montenegro
	option
		id MS
		value Montserrat
	option
		id MA
		value Morocco
	option
		id MZ
		value Mozambique
	option
		id MM
		value Myanmar (ex-Burma)
	option
		id NA
		value Namibia
	option
		id NR
		value Nauru
	option
		id NP
		value Nepal
	option
		id NL
		value Netherlands
	option
		id AN
		value Netherlands Antilles
	option
		id NC
		value New Caledonia
	option
		id NZ
		value New Zealand
	option
		id NI
		value Nicaragua
	option
		id NE
		value Niger
	option
		id NG
		value Nigeria
	option
		id NU
		value Niue
	option
		id NF
		value Norfolk Island
	option
		id MP
		value Northern Mariana Islands 
	option
		id NO
		value Norway
	option
		id OM
		value Oman
	option
		id PK
		value Pakistan
	option
		id PW
		value Palau
	option
		id PS
		value Palestine
	option
		id PA
		value Panama
	option
		id PG
		value Papua New Guinea
	option
		id PY
		value Paraguay
	option
		id PE
		value Peru
	option
		id PH
		value Philippines
	option
		id PN
		value Pitcairn Island
	option
		id PL
		value Poland
	option
		id PT
		value Portugal
	option
		id PR
		value Puerto Rico
	option
		id QA
		value Qatar
	option
		id RE
		value Reunion (FR)
	option
		id RO
		value Romania
	option
		id RU
		value Russia (Russian Federation)
	option
		id RW
		value Rwanda
	option
		id EH
		value Sahara, Western
	option
		id BL
		value Saint Barthelemy (FR)
	option
		id SH
		value Saint Helena (UK)
	option
		id KN
		value Saint Kitts and Nevis
	option
		id LC
		value Saint Lucia
	option
		id MF
		value Saint Martin (FR)
	option
		id PM
		value Saint Pierre & Miquelon (FR)
	option
		id VC
		value Saint Vincent & Grenadines
	option
		id WS
		value Samoa
	option
		id SM
		value San Marino
	option
		id ST
		value Sao Tome and Principe
	option
		id SA
		value Saudi Arabia
	option
		id SN
		value Senegal
	option
		id RS
		value Serbia
	option
		id SC
		value Seychelles
	option
		id SL
		value Sierra Leone
	option
		id SG
		value Singapore
	option
		id SK
		value Slovakia
	option
		id SI
		value Slovenia
	option
		id SB
		value Solomon Islands
	option
		id SO
		value Somalia
	option
		id ZA
		value South Africa
	option
		id GS
		value Saint George & South Sandwich
	option
		id SS
		value South Sudan
	option
		id ES
		value Spain
	option
		id LK
		value Sri Lanka (ex-Ceilan)
	option
		id SD
		value Sudan
	option
		id SR
		value Suriname
	option
		id SJ
		value Svalbard & Jan Mayen Islands
	option
		id SZ
		value Swaziland
	option
		id SE
		value Sweden
	option
		id CH
		value Switzerland
	option
		id SY
		value Syrian Arab Republic
	option
		id TW
		value Taiwan
	option
		id TJ
		value Tajikistan
	option
		id TZ
		value Tanzania, United Republic of
	option
		id TH
		value Thailand
	option
		id TP
		value Timor-Leste (East Timor)
	option
		id TG
		value Togo
	option
		id TK
		value Tokelau
	option
		id TO
		value Tonga
	option
		id TT
		value Trinidad & Tobago
	option
		id TN
		value Tunisia
	option
		id TR
		value Turkey
	option
		id TM
		value Turkmenistan
	option
		id TC
		value Turks and Caicos Islands
	option
		id TV
		value Tuvalu
	option
		id UG
		value Uganda
	option
		id UA
		value Ukraine
	option
		id AE
		value United Arab Emirates
	option
		id UK
		value United Kingdom
	option
		id US
		value United States
	option
		id UM
		value US Minor Outlying Islands
	option
		id UY
		value Uruguay
	option
		id UZ
		value Uzbekistan
	option
		id VU
		value Vanuatu
	option
		id VA
		value Vatican (Holy City)
	option
		id VE
		value Venezuela
	option
		id VN
		value Vietnam
	option
		id VG
		value Virgin Islands, British
	option
		id VI
		value Virgin Islands, U.S.
	option
		id WF
		value Wallis and Futuna
	option
		id EH
		value Western Sahara
	option
		id YE
		value Yemen
	option
		id ZM
		value Zambia
	option
		id ZW
		value Zimbabwe
	option
		id OT
		value Other
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
option-set
	id WeekDay
	option
		id MON
		value Monday
	option
		id TUE
		value Tuesday
	option
		id WED
		value Wednesday
	option
		id THU
		value Thursday
	option
		id FRI
		value Friday
	option 
		id SAT
		value Saturday
	option
		id SUN
		value Sunday
option-set
	id Month
	option
		id JAN
		value January
	option
		id FEB
		value February
	option
		id MAR
		value March
	option
		id APR
		value April
	option
		id MAY
		value May
	option
		id JUN
		value June
	option
		id JUL
		value July
	option
		id AUG
		value August
	option
		id SEP
		value September
	option
		id OCT
		value October
	option
		id NOV
		value November
	option
		id DEC
		value December
option-set
	id TimeZone
	option
		id USPS
		value Express Mail
	option
		id UPS
		value UPS
	option
		id FEDEX
		value Fed Ex

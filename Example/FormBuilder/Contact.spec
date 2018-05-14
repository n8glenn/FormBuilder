// this is a sample form specification file which shows all of the different fields and attributes you can set.
// you may want to use this as a guide to build your own form spec.  notice that the file format is thus:
// [keyword] [value block] // comment
// the value block is everything after the keyword and before the comment or newline character,
// excluding the whitespace before the first character and after the last character.
// you don't need to surround your value block in quotes, but you do need to pay close attention to tabs or spaces which specify indentation.
// indentation determines whether objects represented in this file are siblings or have a parent child relationship.
// for instance, if you want to specify properties for a section, you must use the "section" keyword, then new line
// then make a line with indentation level greater than that of the section line for each property to be specified for that item.
// if a line does not have a greater indentation level, it will be treated as a new object and not a property of your previous object.
// for long text values, such as labels or text areas, you may want to split up the value over multiple lines.
// to do this you simply put an underscore character ("_") at the end of the line, after a trailing space.
// the next line will be a continuation of the value from the previous line, and you can do this as any times as you wish.
// you can also put a comment after the trailing underscore if you want.
// quotation marks do not have to be escaped in value blocks, and if you want to format text with newlines or tabs,
// just use the "\t" or "\n" or "\r" character sequences.

style #Form                         // the default form style class, you can use a custom style class here if you want.
section                             // start the first section
	id Address                      // each element must have an id so we can refer back to it later
	style #Section                  // the default section style class
	title Address Section           // the title for this section, "Address Section".
	collapsible true                // this section is collapsible, default is false
	collapsed false                 // initially show the section as expanded
	allows-add true                 // allow the user to add new items
	add-items                       // here is the list of items the user can add
		section                     // add a new section identical to this one
		image                       // add an image picker to this section
		label                       // add a label to this section
		signature                   // add a signature field to this section
	line                            // here we start specifying the lines to display, each section is composed of lines of data
		id AddressHeading           // the id of this line
		style #Line                 // the default line style class
		field                       // here we specify the fields for this line, each line is composed of one or more fields.
			id AddressHeading       // the id for this field.
			style #Field            // the default field style class
			type heading            // this is a heading field.
			caption Address         // this field has a label of "Address"
	line
		id Street
		field
			id Street
            style #Field
			type text
			caption Street
			required true
	line
		id City
		field
			id City
			type text
			caption City
			required true
	line
		id County
		field
			id County
			type text
			caption County
	line
		id State
		field
            id State
            type combobox
            caption State
            option-set State
            value 1
            required true
	line
		id Province
		visible false
		field
			id Province
			type text
			caption Province
			required true
	line
		id ZipCode
		field
			id ZipCode
			type text
			caption Zip Code
			required true
			requirements
				minimum 5
	line
		id Email
		field
			id Email
			type text
			caption Email
			required true
			requirements
				format email
	line
		id PostalCode
		visible false
		field
			id PostalCode
			type text
			caption Postal Code
			required true
	line
		id BusinessAddress
		field
			id BusinessAddress
			type checkbox
			caption Business Address
			required true
	line
		id Country
		field
			id Country
			type combobox
			caption Country
			option-set Country
			value 1
			required true
	line
		id Delivery
		field
			id Delivery
			type optionset
			caption Delivery Type
			option-set Delivery
			value 1
	line
		id TextFields
		field
			id Text1
			type label
			caption Text 1 222 _ // this is how you continue a value block on the next line, with an "_" character.
                        3333 _ // you can do it as many times as you want.
                        \n\t"4444" // notice the \r and \t to format text, you can also use \n, quotes aren't escaped.
		field
			id Text2
			type label
			caption Text 2
			value test text here 2
		field
			id Text3
			type label
			caption Text 3 test text here 3 test test test test test test test test test test test test 2
			value test text here 3 test test test test test test test test test test test test
	line
		id TextAreas
		field
			id TextArea1
			type textarea
			caption Text Area 1
			value test text here
			required true
		field
			id TextArea2
			type textarea
			caption Text Area 2 test test test test test test test test test test test test test test 2
			value Text Area 2 test test test test test test test test test test test test test test 2 Text Area 2 test test test test test test test test test test test test test test 2
			required true
	line
		id Image
		field
			id welcome
			type image
			caption you're welcome!
			value welcome
	line
		id StartDate
		field
			id StartDate
			type datepicker
			caption Start Date
			required true
			date-mode date
	line 
		id MyImage
		field
			id MyImage
			type imagepicker
			caption Select an Image!
			required true
			picker-mode album
	line
		id Signature
		field
			id Signature
			type signature
			caption Sign Here!
			required true






	

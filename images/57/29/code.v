module top_module(
		d1,
		d2,
		d3,
		d4,
		control,
		digit
);input [3:0]  d1;
			input [3:0]  d2;
			input [3:0]  d3;
			input [3:0]  d4;
			input [1:0]  control;
			output [3:0] digit;  
   




			
			assign digit = (control == 2'b11) ? d1 : 
								(control == 2'b10) ? d2 : 
								(control == 2'b01) ? d3 : 
								d4;
   
endmodule
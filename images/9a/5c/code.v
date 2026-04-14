module top_module( dataa, datab, result, display);input [31:0] dataa;
	input [31:0] datab;
	output [31:0] result;
	output [10:0] display;
   
	assign display [10:8] = dataa[2:0];
	assign display [7:0]  = datab [7:0];

	

	
	

	
	
endmodule
module top_module(O,I0,I1,S);input wire [3:0]I0; 
	input wire [3:0]I1; 
	input wire S; 
	output wire [3:0]O; 
	
	assign O[0] = (~S&I0[0]) | (S&I1[0]); 
	assign O[1] = (~S&I0[1]) | (S&I1[1]); 
	assign O[2] = (~S&I0[2]) | (S&I1[2]); 
	assign O[3] = (~S&I0[3]) | (S&I1[3]); 
	
endmodule
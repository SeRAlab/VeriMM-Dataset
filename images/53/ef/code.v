module top_module(rest , A, B, Out);input rest ; 
	input [15:0] A , B ; 
	output [15:0] Out ; 

	reg [15:0] Out_register ; 
	assign Out = Out_register ; 
always @(rest , A, B) begin 
	
	if (rest) 
		Out_register <= 0 ; 
	else 
		Out_register <= A + B ; 

	end
endmodule
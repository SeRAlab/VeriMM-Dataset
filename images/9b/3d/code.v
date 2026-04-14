module top_module(x,z);input [15:0] x; 
output reg [31:0] z; 

always @ (x) begin
 
	if(x[15] == 1) begin
		z = { 16'b1111111111111111, x };
 	end

	 else if(x[15] == 0) begin
 		z= { 16'b0000000000000000, x };
 	end

end

endmodule
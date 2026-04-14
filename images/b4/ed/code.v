module top_module( clk, rst, in, out  );parameter WORD_SIZE = 32 ; 
	
	input wire clk, rst;
	input wire [WORD_SIZE-1:0] in;
	output reg [WORD_SIZE-1:0] out;	
	
always @ (posedge rst or posedge clk ) begin
	if ( rst ) begin
		out <= { WORD_SIZE {1'b0} };
	end else if ( clk ) begin
		out <= in;
	end
end

endmodule
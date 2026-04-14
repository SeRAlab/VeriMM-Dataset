module top_module(pcIn, pcOut);input [31:0] pcIn;
	output [31:0] pcOut;
	reg [31:0] pcOut;
	
	always @(*) begin
		pcOut <= pcIn + 31'd4;
	end
endmodule
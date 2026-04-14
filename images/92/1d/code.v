module top_module(add_in1, add_in2, add_out);input [31:0] add_in1, add_in2;
	
	output reg [31:0] add_out;
	
	always @(*)
	begin
	
		add_out <= add_in1 + add_in2;
	
	end

endmodule
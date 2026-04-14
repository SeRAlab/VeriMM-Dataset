module top_module(
	input [31:0] inALUOut,
	input reset, clk,
	output [31:0] outALUOut
    );reg [31:0] registerALUOut;
	
	assign outALUOut = registerALUOut;
	
	always@(posedge clk)
		begin
			if (reset)
				begin
					registerALUOut <= 32'b0;
				end
			else
				begin
					registerALUOut <= inALUOut;
				end
		end

endmodule
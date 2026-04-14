module top_module(
	input clk,
	input cchld,
	input pcen,
	input loopen,
	input reset,
	input enable,
	
	
	input [15:0] rn,
	input [15:0] incoming_data,
	output reg [15:0] pc );always @( posedge clk )
	begin
		if (reset)
		begin
			pc <= {16{1'b0}};
		end
		else if (~cchld)
		begin
			if (enable)
			begin
				pc <= incoming_data;
			end
			else if (loopen)
			begin
				pc <= rn;
			end
			else if (pcen)
			begin
				pc <= pc + 1;
			end
		end
	end

endmodule
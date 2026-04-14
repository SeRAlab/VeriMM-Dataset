module top_module(
	input        rstb,
	input        clk,
	input        inp_valid,
	input  [3:0] inp_data,
	output       out_valid,
	output [3:0] out_data
);always @(posedge clk or negedge rstb) begin
		if(!rstb) begin

		end
		else begin

		end
	end

endmodule
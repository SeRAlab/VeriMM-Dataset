module top_module(
	input clk,
	input [1:0] sel,
	input [3:0] data_in,
	output reg data_out);always @(posedge clk) begin
		case (sel)
			2'b00: data_out <= data_in[0];
			2'b01: data_out <= data_in[1];
			2'b10: data_out <= data_in[2];
			2'b11: data_out <= data_in[3];
		endcase
	end

endmodule
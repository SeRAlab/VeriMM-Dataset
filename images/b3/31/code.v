module top_module(clk, load, data, shift, reset, out);input clk, load, shift, reset;
	input [15:0] data;
	output [15:0] out;
	reg [15:0] reg_out;

	always @ (posedge clk) begin
		if (reset) begin
			reg_out <= 16'b0;
		end else if (load) begin
			reg_out <= data;
		end else if (shift) begin
			reg_out <= {reg_out[14:0], 1'b0};
		end
	end

	assign out = reg_out;
endmodule
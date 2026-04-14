module top_module(clk, reset, load, data_in, shift_out, data_out);input clk;
	input reset;
	input load;
	input [3:0] data_in;
	output shift_out;
	output [3:0] data_out;

	reg [3:0] reg_data;

	always @(posedge clk) begin
		if (reset) begin
			reg_data <= 4'b0;
		end else if (load) begin
			reg_data <= data_in;
		end else begin
			reg_data[3] <= reg_data[2];
			reg_data[2] <= reg_data[1];
			reg_data[1] <= reg_data[0];
			reg_data[0] <= 1'b0;
		end
	end

	assign shift_out = reg_data[3];
	assign data_out = reg_data;

endmodule
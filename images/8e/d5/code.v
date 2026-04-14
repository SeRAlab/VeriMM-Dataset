module shift_register_lr (
	input clk,
	input rst,
	input shift_dir,
	input [3:0] data_in,
	output reg [3:0] reg_out);always @(posedge clk) begin
		if (rst)
			reg_out <= 4'b0000;
		else if (shift_dir)
			reg_out <= {reg_out[2:0], data_in[3]};
		else
			reg_out <= {data_in[0], reg_out[3:1]};
	end
	
endmodule
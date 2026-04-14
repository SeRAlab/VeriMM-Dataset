module parallel_load_register (
	input clk,
	input enable,
	input [3:0] data,
	output [3:0] q);reg [3:0] reg_data = 4'b0000;

	always @(posedge clk) begin
		if (enable)
			reg_data <= data;
	end
	
	assign q = reg_data;
	
endmodule
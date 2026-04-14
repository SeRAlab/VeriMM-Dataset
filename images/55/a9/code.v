module counter_3bit (
	input clk,
	input rst,
	input load,
	input enable,
	input [2:0] parallel_data,
	output reg [2:0] count
);

	always @(posedge clk) begin
		if (rst) begin
			count <= 3'd0;
		end else if (load) begin
			count <= parallel_data;
		end else if (enable) begin
			count <= count + 1;
		end
	end
endmodule
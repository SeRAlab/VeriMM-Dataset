module top_module(
		input  wire  clk,
		input  wire  rst,
		output reg   [2:0] count
	);reg [2:0] reg_count;

	always @(posedge clk) begin
		if (rst) begin
			reg_count <= 3'b0;
		end else begin
			reg_count <= reg_count + 1;
		end
	end

	assign count = reg_count;

endmodule
module binary_adder(
	input clk,
	input rst_n,
	input [3:0] a,
	input [3:0] b,
	input cin,
	output reg [3:0] sum,
	output reg cout
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			sum <= 4'b0;
			cout <= 1'b0;
		end else begin
			{cout, sum} <= a + b + cin;
		end
	end
	
endmodule
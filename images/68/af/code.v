module top_module(d1,d2,d3,
					r,clk,q1,q2,q3
    );input r;
	input clk;
	input [1:0] d1;
	input [31:0]d2;
	input [4:0] d3;
	output [1:0] q1;
	output [31:0] q2;
	output [4:0] q3;
	reg [1:0] q1;
	reg [31:0] q2;
	reg [4:0] q3;
	always @ (posedge clk)
	if (r)
		begin
			q1 <= 0;
			q2 <= 0;
			q3 <= 0;
		end
	else
		begin
			q1 <= d1;
			q2 <= d2;
			q3 <= d3;
		end
endmodule
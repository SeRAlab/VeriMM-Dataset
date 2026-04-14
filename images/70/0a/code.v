module top_module(
	input [1:0] sel,
	input [4:0] a,
	input [4:0] b,
	input [4:0] c,
	input [4:0] d,
	output reg [4:0] o
    );always @(*) begin
	 case (sel)
	 2'b00: o = a;
	 2'b01: o = b;
	 2'b10: o = c;
	 2'b11: o = d;
	 endcase
	 end
endmodule
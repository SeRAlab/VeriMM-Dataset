module top_module(
	input [5:0] x,
   input [3:0] shift,
   output reg [11:0] out
   );integer i;

always @(*) begin
	out[11:10] = 2'b10;
	out[9:6] = 4'bx;
	i = shift[3:1];
	case (shift[0])
		1'b0: out[5:0] = x << i;
		1'b1: out[5:0] = x >> i;
	endcase
end

endmodule
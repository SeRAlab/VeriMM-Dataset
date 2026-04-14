module top_module(
	input [1:0]select,
	input [31:0]din0,din1,din2,din3,
	output reg [31:0]dout
   );always@(*)
	begin
		case(select)
			2'b00: dout = din0;
			2'b01: dout = din1;
			2'b10: dout = din2;
			2'b11: dout = din3;
			default: dout = 32'bx;
		endcase
	end

endmodule
module mux_4to1 (SEL, IN0, IN1, IN2, IN3, OUT);
input [1:0] SEL;
input IN0, IN1, IN2, IN3;
output reg OUT;

always @(*) begin
	case (SEL)
		2'b00: OUT = IN0;
		2'b01: OUT = IN1;
		2'b10: OUT = IN2;
		2'b11: OUT = IN3;
		default: OUT = 1'b0;
	endcase
end

endmodule
module top_module(
input [31:0] _00,
input [31:0] _01,
input [31:0] _10,
input [31:0] _11,
input [1:0] Sel,
output [31:0] OutMux
);reg [31:0] OutMux_reg;
always@(*) begin
	case(Sel)
		2'b00: begin
			OutMux_reg = _00;
		end
		2'b01: begin
			OutMux_reg = _01;
		end
		2'b10: begin
			OutMux_reg = _10;
		end
		2'b11: begin
			OutMux_reg = _11;
		end
		default: begin
			OutMux_reg = _00;
		end
	endcase	
end
assign OutMux = OutMux_reg;
endmodule
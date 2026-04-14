module top_module(
input [31:0] a,
input [4:0] shamt,
input [1:0] stype,
output  reg [31:0] r
);always @(*) begin
		case(stype)
		2'b00: r = a >> shamt; 
		2'b01: r = a << shamt; 
		2'b10:  r = a >>> shamt; 
		default: r=a;
		endcase
	end
endmodule
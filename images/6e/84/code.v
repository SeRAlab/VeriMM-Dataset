module top_module(
	Ra,
	Rb,
	aluOut,
	aluControl,
	IR
);input [15:0] Ra;
input [15:0] Rb;
input [5:0] IR;
input [1:0] aluControl;
output [15:0] aluOut;

wire [15:0] input_a;
wire [15:0] input_b;
wire [15:0] imm;

assign imm = { {12{IR[4]}}, IR[4:0] };

assign input_b = IR[5] ? imm : Rb;
assign input_a = Ra;

assign aluOut = (aluControl == 0) ? input_a :
					 (aluControl == 1) ? input_a + input_b :
					 (aluControl == 2) ? input_a & input_b :
					 ~input_a;
					 
endmodule
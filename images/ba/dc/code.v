module top_module(
    input [15:0] Ra,
    input [15:0] Rb,
    input [5:0] IR,
    input [1:0] aluControl,
    output [15:0] aluOut
    );wire [15:0] opA;
	 
	 assign opA = (IR[5] == 1'b0) ? Rb : {{11{IR[4]}}, IR[4:0]};
	
	 assign aluOut = 	aluControl == 2'b00 ? Ra :
							aluControl == 2'b01 ? (Ra + opA) :
							aluControl == 2'b10 ? (Ra & opA) :
							~Ra;
endmodule
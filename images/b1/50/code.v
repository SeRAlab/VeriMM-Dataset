module top_module(
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUOp,
    output [31:0] C
    );assign C = ALUOp == 3'h0 ? A + B :
			   ALUOp == 3'h1 ? A - B :
			   ALUOp == 3'h2 ? A & B :
			   ALUOp == 3'h3 ? A | B :
			   ALUOp == 3'h4 ? A >> B :
			   ALUOp == 3'h5 ? $signed($signed(A) >>> B) : 0;


endmodule
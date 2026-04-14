module top_module(output [3:0] ALU_Out_EQ,input [3:0] A, input [3:0] B,input [3:0] ALU_Sel);assign ALU_Out_EQ = (A==B)?4'd1:4'd0 ;
endmodule
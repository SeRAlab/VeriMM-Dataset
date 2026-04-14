module top_module(ALUOp, bit_30, bit_25, function3, control);input bit_30;
input bit_25; 
input [2:0] ALUOp ; 
input [2:0] function3;

output [3:0] control ; 
assign control[0] = ALUOp[2] & ALUOp[1] & (!ALUOp[0]) & function3[2];
assign control[1] = function3[1] & ALUOp[1];
assign control[2] = bit_25 & ALUOp[0] & ALUOp[1] & ALUOp[2] ;
assign control[3] = (!ALUOp[2]) | (bit_30 & ALUOp[2] & ALUOp[1] & ALUOp[0] );endmodule
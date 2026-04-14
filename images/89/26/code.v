module top_module(op0, op1, op2, op3, select, result);input [31:0] op0, op1, op2, op3; 
 input [1:0] select; 
 output [31:0] result; 
 assign result = select[1]? (select[0]? op3: op2) 
  :(select[0]? op1: op0); 
 endmodule
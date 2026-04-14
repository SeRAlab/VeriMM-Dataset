module top_module(input clk,rst,input [2:0] operator,input [15:0] op1,op2,output reg [15:0] out, status);`define numBits 16 
  `define operatorSize 4 
  always@(*) begin 
  if(rst == 1'b0) begin 
  out <= `numBits'd0; 
  end else begin 
  case(operator) 
  `operatorSize'h0: 
  out <= op1 + op2; 
  `operatorSize'h1: 
  out <= op2 - op1; 
  `operatorSize'h2: 
  out <= (op1 * op2); 
  `operatorSize'h3: 
  out <= ~(op1 & op2); 
  `operatorSize'h4: 
  out <= op1 / op2; 
  `operatorSize'h5: 
  out <= op1 % op2; 
  `operatorSize'h6: 
  out <= op1 < op2; 
  `operatorSize'h7: 
  out <= op1 <= op2; 
  default: 
  out <= `numBits'd0; 
  endcase 
  end 
  end 
  always@(posedge clk or negedge rst) begin 
  if(rst == 1'b0) begin 
  status = `numBits'd0; 
  end else begin 
  status <= out; 
  end 
  end 
 endmodule
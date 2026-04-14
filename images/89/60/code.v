module top_module(input clock,input ready,output reg listA_req,input listA_ack,input [7:0] listA_value,input listA_value_valid,output reg listB_req,input listB_ack,input [7:0] listB_value,input listB_value_valid,input req,output reg ack,output reg [7:0] value,output reg value_valid);reg lastSelectA; 
  wire selectA; 
  assign selectA = lastSelectA & (listA_ack ? listA_value_valid : 1'b1); 
  always @(posedge clock) begin 
  if(ready) 
  lastSelectA <= selectA; 
  else 
  lastSelectA <= 1; 
  end 
  always @(*) begin 
  if(selectA) begin 
  listA_req = req; 
  ack = listA_ack; 
  value = listA_value; 
  value_valid = listA_value_valid; 
  listB_req = 0; 
  end else begin 
  listB_req = req; 
  ack = listB_ack; 
  value = listB_value; 
  value_valid = listB_value_valid; 
  listA_req = 0; 
  end 
  end 
 endmodule
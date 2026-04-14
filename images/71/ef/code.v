module top_module(input clock,input ready,input [7:0] head,output reg tail_req,input tail_ack,input [7:0] tail_value,input tail_value_valid,input req,output reg ack,output reg [7:0] value,output reg value_valid);reg headShown; 
  reg selectHead; 
  reg lastReq; 
  reg headAck; 
  always @(posedge clock) begin 
  lastReq <= req; 
  if(ready) begin 
  if(~lastReq & req) begin 
  headAck <= 1; 
  headShown <= 1; 
  if(headShown) 
  selectHead <= 0; 
  end else begin 
  headAck <= 0; 
  end 
  end else begin 
  headShown <= 0; 
  selectHead <= 1; 
  headAck <= 0; 
  end 
  end 
  always @(*) begin 
  if(selectHead) begin 
  ack = headAck; 
  value = head; 
  value_valid = 1; 
  tail_req = 0; 
  end else begin 
  tail_req = req; 
  ack = tail_ack; 
  value = tail_value; 
  value_valid = tail_value_valid; 
  end 
  end 
 endmodule
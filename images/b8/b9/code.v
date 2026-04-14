module top_module(input clock,input ready,output reg done,output reg list_req,input list_ack,input [7:0] list_value,input list_value_valid,output reg [7:0] head,output reg head_valid,input tail_req,output reg tail_ack,output reg [7:0] tail_value,output reg tail_value_valid);reg nextDone; 
  always @(posedge clock) begin 
  if(ready) begin 
  done <= done | nextDone; 
  if(~done & list_ack) begin 
  nextDone <= 1'b1; 
  head <= list_value; 
  head_valid <= list_value_valid; 
  end else begin 
  nextDone <= 1'b0; 
  end 
  end else begin 
  done <= 1'b0; 
  nextDone <= 1'b0; 
  head <= 8'hFF; 
  head_valid = 1'b0; 
  end 
  end 
  always @(*) begin 
  list_req = ready & ~done; 
  if(done) begin 
  list_req = tail_req; 
  tail_ack = list_ack; 
  tail_value = list_value; 
  tail_value_valid = list_value_valid; 
  end else begin 
  list_req = ready & ~nextDone; 
  tail_ack = 1'b0; 
  tail_value = 8'hFF; 
  tail_value_valid = 1'b0; 
  end 
  end 
 endmodule
module top_module(input clk,input rst,input rxd,output [7:0] data,output received);localparam STATE1 = 2'b00; 
 localparam STATE2 = 2'b01; 
 localparam STATE3 = 2'b10; 
 reg [1:0] state = STATE1; 
 reg [7:0] tmp_data = 8'b00000000; 
 reg tmp_received = 1'b0; 
 reg [2:0] index; 
 reg [1:0] rxd_hist = 2'b11; 
 always @(posedge clk) 
 begin 
  if(rst) 
  begin 
  tmp_data = 0; 
  tmp_received = 0; 
  rxd_hist = 2'b11; 
  state = STATE1; 
  end 
  case(state) 
  STATE1: 
  begin 
  if(rxd_hist == 2'b00 && rxd == 1) 
  begin 
  rxd_hist = 2'b11; 
  tmp_data = 8'b00000000; 
  index = 3'b000; 
  state = STATE2; 
  end 
  end 
  STATE2: 
  begin 
  tmp_data[index] = rxd; 
  index = index + 1; 
  if(index == 3'b000) 
  begin 
  tmp_received = 1'b1; 
  state = STATE3; 
  index = 3'b000; 
  end 
  end 
  STATE3: 
  begin 
  tmp_received = 1'b0; 
  tmp_data = 8'b00000000; 
  state = STATE1; 
  end 
  endcase 
  if(state == STATE1) rxd_hist = { rxd_hist[0], rxd }; 
 end 
 assign data = tmp_data; 
 assign received = tmp_received; 
 endmodule
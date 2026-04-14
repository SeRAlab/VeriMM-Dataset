module top_module(input clk_i,input rst_i,input flush_i,input stb_i,input [15:0] di,output can_burst_o,output do8_valid,output reg [7:0] do8,input next_i);reg [15:0] storage[0:7]; 
 reg [2:0] produce; 
 reg [3:0] consume; 
 reg [3:0] level; 
 wire [15:0] do16; 
 assign do16 = storage[consume[3:1]]; 
 always @(*) begin 
  case(consume[0]) 
  1'd0: do8 <= do16[15:8]; 
  1'd1: do8 <= do16[7:0]; 
  endcase 
 end 
 always @(posedge clk_i) begin 
  if(rst_i) begin 
  produce = 3'd0; 
  consume = 4'd0; 
  level = 4'd0; 
  end else begin 
  if(stb_i) begin 
  storage[produce] = di; 
  produce = produce + 3'd1; 
  level = level + 4'd2; 
  end 
  if(next_i) begin 
  consume = consume + 4'd1; 
  level = level - 4'd1; 
  end 
  end 
 end 
 assign do8_valid = ~(level == 4'd0); 
 assign can_burst_o = level >= 4'd14; 
 endmodule
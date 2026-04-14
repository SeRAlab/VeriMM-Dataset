module top_module(input wire clk,output reg [15:0] pos1,output reg [15:0] pos2,input wire sensor,input wire [1:0] clear,input wire subtract,input wire [15:0] distance);reg sensor_prev; 
  initial begin 
  pos1 = 16'b0; 
  pos2 = 16'b0; 
  sensor_prev = 1'b0; 
  end 
  always @ (posedge clk) begin 
  if (clear[1] | clear[0]) begin 
  if (clear[0]) pos1 <= 16'b0; 
  if (clear[1]) pos2 <= 16'b0; 
  end else if (subtract) begin 
  pos2 <= pos2 - distance; 
  end else if (~sensor_prev & sensor) begin 
  pos1 <= pos1 + 1'b1; 
  pos2 <= pos2 + 1'b1; 
  end 
  sensor_prev <= sensor; 
  end 
 endmodule
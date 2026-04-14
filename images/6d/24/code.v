module top_module(input wire clk,input wire en_tone,input wire en_noise,input wire tone,input wire noise,input wire [3:0] amplitude_l,input wire [3:0] amplitude_r,output reg [4:0] out_l,output reg [4:0] out_r);reg [4:0] next_out_l, next_out_r; 
  always @* begin 
  next_out_l = 5'b0000; 
  next_out_r = 5'b0000; 
  if (en_tone == 1'b1) 
  if (tone == 1'b1) begin 
  next_out_l = next_out_l + {1'b0, amplitude_l}; 
  next_out_r = next_out_r + {1'b0, amplitude_r}; 
  end 
  if (en_noise == 1'b1) 
  if (noise == 1'b1) begin 
  next_out_l = next_out_l + {1'b0, amplitude_l}; 
  next_out_r = next_out_r + {1'b0, amplitude_r}; 
  end 
  end 
  always @(posedge clk) begin 
  out_l <= next_out_l; 
  out_r <= next_out_r; 
  end 
 endmodule
module top_module(input wire clk,input wire rst_n,input wire pulse_from_gen,input wire [1:0] noise_freq,output wire out);reg [10:0] fcounter; 
  always @* begin 
  case (noise_freq) 
  2'd0: fcounter = 11'd255; 
  2'd1: fcounter = 11'd511; 
  2'd2: fcounter = 11'd1023; 
  default: fcounter = 11'd2047; 
  endcase 
  end 
  reg [10:0] count = 11'd0; 
  always @(posedge clk) begin 
  if (count == fcounter) 
  count <= 11'd0; 
  else 
  count <= count + 1; 
  end 
  reg [30:0] lfsr = 31'h11111111; 
  always @(posedge clk) begin 
  if (rst_n == 1'b0) 
  lfsr <= 31'h11111111; 
 if ((noise_freq == 2'd3 && pulse_from_gen == 1'b1) ||(noise_freq != 2'd3 && count == fcounter)) begin 
  if ((lfsr[2] ^ lfsr[30]) == 1'b1) 
  lfsr <= {lfsr[29:0], 1'b1}; 
  else 
  lfsr <= {lfsr[29:0], 1'b0}; 
  end 
  end 
  assign out = lfsr[0]; 
 endmodule
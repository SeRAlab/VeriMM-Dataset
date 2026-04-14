module top_module(input clk,input rstn,input [31:0] afl,output reg frac_flag);reg [47:0] mant; 
  always @* begin 
  if(afl[30]) mant = {1'b1, afl[22:0]} << (afl[30:23] - 127); 
  else mant = {1'b1, afl[22:0]} >> (127 - afl[30:23]); 
  end 
  always @(posedge clk, negedge rstn) begin 
  if(!rstn) frac_flag <= 1'b0; 
  else begin 
  if(|mant[23:0]) frac_flag <= 1'b1; 
  else frac_flag <= 1'b0; 
  end 
  end 
 endmodule
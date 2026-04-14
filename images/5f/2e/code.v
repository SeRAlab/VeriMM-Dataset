module top_module( CLK, W_OUT_REG, DIN, OUT_REG);parameter out_width = 7; 
 input CLK; 
 input W_OUT_REG; 
 input [31:0] DIN; 
 output reg [out_width:0] OUT_REG; 
  always @(posedge CLK) if (W_OUT_REG) OUT_REG <= DIN[out_width:0]; 
 endmodule
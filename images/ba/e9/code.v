module top_module(addr, out, clk);input clk; 
  output [15:0] out; 
  reg [15:0] out, out2, out3; 
  input [4:0] addr; 
  always @(posedge clk) begin 
  out2 <= out3; 
  out <= out2; 
  case(addr) 
  0: out3 <= 16'h4000; 
  1: out3 <= 16'h3fb1; 
  2: out3 <= 16'h3ec5; 
  3: out3 <= 16'h3d3f; 
  4: out3 <= 16'h3b21; 
  5: out3 <= 16'h3871; 
  6: out3 <= 16'h3537; 
  7: out3 <= 16'h3179; 
  8: out3 <= 16'h2d41; 
  9: out3 <= 16'h289a; 
  10: out3 <= 16'h238e; 
  11: out3 <= 16'h1e2b; 
  12: out3 <= 16'h187e; 
  13: out3 <= 16'h1294; 
  14: out3 <= 16'hc7c; 
  15: out3 <= 16'h646; 
  16: out3 <= 16'h0; 
  17: out3 <= 16'hf9ba; 
  18: out3 <= 16'hf384; 
  19: out3 <= 16'hed6c; 
  20: out3 <= 16'he782; 
  21: out3 <= 16'he1d5; 
  22: out3 <= 16'hdc72; 
  23: out3 <= 16'hd766; 
  24: out3 <= 16'hd2bf; 
  25: out3 <= 16'hce87; 
  26: out3 <= 16'hcac9; 
  27: out3 <= 16'hc78f; 
  28: out3 <= 16'hc4df; 
  29: out3 <= 16'hc2c1; 
  30: out3 <= 16'hc13b; 
  31: out3 <= 16'hc04f; 
  default: out3 <= 0; 
  endcase 
  end 
 endmodule
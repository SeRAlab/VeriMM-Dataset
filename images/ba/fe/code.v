module top_module(addr, out, clk);input clk; 
  output [15:0] out; 
  reg [15:0] out, out2, out3; 
  input [4:0] addr; 
  always @(posedge clk) begin 
  out2 <= out3; 
  out <= out2; 
  case(addr) 
  0: out3 <= 16'h0; 
  1: out3 <= 16'hf9ba; 
  2: out3 <= 16'hf384; 
  3: out3 <= 16'hed6c; 
  4: out3 <= 16'he782; 
  5: out3 <= 16'he1d5; 
  6: out3 <= 16'hdc72; 
  7: out3 <= 16'hd766; 
  8: out3 <= 16'hd2bf; 
  9: out3 <= 16'hce87; 
  10: out3 <= 16'hcac9; 
  11: out3 <= 16'hc78f; 
  12: out3 <= 16'hc4df; 
  13: out3 <= 16'hc2c1; 
  14: out3 <= 16'hc13b; 
  15: out3 <= 16'hc04f; 
  16: out3 <= 16'hc000; 
  17: out3 <= 16'hc04f; 
  18: out3 <= 16'hc13b; 
  19: out3 <= 16'hc2c1; 
  20: out3 <= 16'hc4df; 
  21: out3 <= 16'hc78f; 
  22: out3 <= 16'hcac9; 
  23: out3 <= 16'hce87; 
  24: out3 <= 16'hd2bf; 
  25: out3 <= 16'hd766; 
  26: out3 <= 16'hdc72; 
  27: out3 <= 16'he1d5; 
  28: out3 <= 16'he782; 
  29: out3 <= 16'hed6c; 
  30: out3 <= 16'hf384; 
  31: out3 <= 16'hf9ba; 
  default: out3 <= 0; 
  endcase 
  end 
 endmodule
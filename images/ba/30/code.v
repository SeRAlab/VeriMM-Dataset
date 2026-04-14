module top_module(addr, out, clk);input clk; 
  output [15:0] out; 
  reg [15:0] out, out2, out3; 
  input [3:0] addr; 
  always @(posedge clk) begin 
  out2 <= out3; 
  out <= out2; 
  case(addr) 
  0: out3 <= 16'h0; 
  1: out3 <= 16'hf384; 
  2: out3 <= 16'he782; 
  3: out3 <= 16'hdc72; 
  4: out3 <= 16'hd2bf; 
  5: out3 <= 16'hcac9; 
  6: out3 <= 16'hc4df; 
  7: out3 <= 16'hc13b; 
  8: out3 <= 16'hc000; 
  9: out3 <= 16'hc13b; 
  10: out3 <= 16'hc4df; 
  11: out3 <= 16'hcac9; 
  12: out3 <= 16'hd2bf; 
  13: out3 <= 16'hdc72; 
  14: out3 <= 16'he782; 
  15: out3 <= 16'hf384; 
  default: out3 <= 0; 
  endcase 
  end 
 endmodule
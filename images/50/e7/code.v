module top_module(addr, mod, eff_addr);input [31:0] addr; 
  output [7:0] mod; 
  output [31:0] eff_addr; 
  assign mod = (addr[31:20] == 12'h000) ? 0 : 
  (addr[31:24] == 8'h10) ? 1 : 
  (addr[31:20] == 12'hf00) ? 2 : 
  (addr[31:20] == 12'hf01) ? 3 : 
  (addr[31:20] == 12'hf02) ? 4 : 
  (addr[31:20] == 12'hf03) ? 5 : 
  (addr[31:20] == 12'hf04) ? 6 : 
  (addr[31:20] == 12'hf05) ? 7 : 
  (addr[31:20] == 12'hf06) ? 8 : 
  (addr[31:20] == 12'hf07) ? 10 : 
  (addr[31:20] == 12'hf08) ? 11 : 
  (addr[31:20] == 12'hf0a) ? 9 : 
  0; 
  assign eff_addr = (mod == 8'h01) ? {8'h00,addr[23:0]} : {12'h000,addr[19:0]}; 
 endmodule
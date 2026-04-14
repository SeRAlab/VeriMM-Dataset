module top_module(input c,input [ 4:0] addr,output reg [31:0] q);initial q = 32'h0; 
 always @(posedge c) begin 
  case (addr) 
  5'h00: q = 32'hc680_0000; 
  5'h01: q = 32'h3bd5_5555; 
  5'h02: q = 32'h3f2a_aaab; 
  5'h03: q = 32'hbeaa_aaab; 
  5'h04: q = 32'h3f13_cd36; 
  5'h05: q = 32'hbf13_cd36; 
  5'h06: q = 32'hbf80_0000; 
  5'h07: q = 32'hbf00_0000; 
  5'h08: q = 32'h3f5d_ddde; 
  5'h09: q = 32'h451f_f000; 
  5'h0a: q = 32'h424c_b852; 
  5'h0b: q = 32'h459f_f800; 
  5'h0c: q = 32'h3856_bf95; 
  5'h0d: q = 32'h3f00_0000; 
  5'h0e: q = 32'h4680_0000; 
  5'h0f: q = 32'h40c9_0fdb; 
  5'h10: q = 32'h3fc9_0fdb; 
  5'h11: q = 32'h39c9_0fdb; 
  5'h12: q = 32'h0; 
  5'h13: q = 32'h0; 
  5'h14: q = 32'h0; 
  5'h15: q = 32'h0; 
  5'h16: q = 32'h0; 
  5'h17: q = 32'h0; 
  5'h18: q = 32'h0; 
  5'h19: q = 32'h0; 
  5'h1a: q = 32'h0; 
  5'h1b: q = 32'h0; 
  5'h1c: q = 32'h0; 
  5'h1d: q = 32'h0; 
  5'h1e: q = 32'h0; 
  5'h1f: q = 32'h0; 
  endcase 
 end 
 endmodule
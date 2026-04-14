module top_module(idx, base, fd, sd);input [6:0] idx; 
 output [26:0] base; 
 output [17:0] fd; 
 output [10:0] sd; 
 reg [26:0] base; 
 reg [17:0] fd; 
 reg [10:0] sd; 
 always @(idx) 
  case (idx) 
  7'h00 : begin base = 27'h3fffffe; fd = 18'h3fff7; sd = 11'h7e8; end 
  7'h01 : begin base = 27'h3f01fbf; fd = 18'h3f027; sd = 11'h7ba; end 
  7'h02 : begin base = 27'h3e07e06; fd = 18'h3e0b4; sd = 11'h78d; end 
  7'h7b : begin base = 27'h01465fe; fd = 18'h10a4c; sd = 11'h10e; end 
  7'h7c : begin base = 27'h0104104; fd = 18'h10830; sd = 11'h10a; end 
  7'h7d : begin base = 27'h00c246d; fd = 18'h1061b; sd = 11'h108; end 
  7'h7e : begin base = 27'h0081020; fd = 18'h1040b; sd = 11'h104; end 
  7'h7f : begin base = 27'h0040404; fd = 18'h10202; sd = 11'h101; end 
  endcase 
 endmodule
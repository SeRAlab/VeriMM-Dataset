module top_module(input clock, input reset, input enable, input clear,input signed [15:0] x, input signed [15:0] y,input [7:0] shift, output [15:0] z );reg signed [30:0] product; 
  reg signed [39:0] z_int; 
  reg signed [15:0] z_shift; 
  reg enable_d1; 
  always @(posedge clock) 
  enable_d1 <= #1 enable; 
  always @(posedge clock) 
  if(reset | clear) 
  z_int <= #1 40'd0; 
  else if(enable_d1) 
  z_int <= #1 z_int + {{9{product[30]}},product}; 
  always @(posedge clock) 
  product <= #1 x*y; 
  always @* 
  case(shift) 
  8'd6 : z_shift <= z_int[33:18]; 
  8'd7 : z_shift <= z_int[32:17]; 
  8'd8 : z_shift <= z_int[31:16]; 
  8'd9 : z_shift <= z_int[30:15]; 
  8'd10 : z_shift <= z_int[29:14]; 
  8'd11 : z_shift <= z_int[28:13]; 
  default : z_shift <= z_int[15:0]; 
  endcase 
  assign z = z_int[15:0]; 
 endmodule
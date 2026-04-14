module top_module(input wire [15:0] in_a,input wire [15:0] in_b,output reg [15:0] out,input wire op,input wire enable,output wire z,output wire n);always @(*) 
  begin 
  if (enable == 1'b0) 
  out = in_b; 
  else 
  case (op) 
  2'b00: out = in_a + in_b; 
  2'b01: out = in_a - in_b; 
  2'b10: out = {in_b[15], in_b[15:1]}; 
  2'b11: out = in_a & in_b; 
  endcase 
  end 
  assign z = ~|out; 
  assign n = out[15]; 
 endmodule
module top_module(input wire [1:0] sel,input wire [31:0] a,input wire [31:0] b,input wire [31:0] c,input wire [31:0] d,output reg [31:0] o);always @(*) 
  case(sel) 
  2'b00: o<=a; 
  2'b01: o<=b; 
  2'b10: o<=c; 
  2'b11: o<=d; 
  endcase 
 endmodule
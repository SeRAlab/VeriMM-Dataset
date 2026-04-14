module top_module(input [31 : 0] a,input [31 : 0] b,input carry_in,output wire [31 : 0] sum,output wire carry_out);reg [32 : 0] adder_result; 
  assign sum = adder_result[31:0]; 
  assign carry_out = adder_result[32]; 
  always @(a, b, carry_in) 
  adder_result = {1'b0, a} + {1'b0, b} + {32'b0, carry_in}; 
 endmodule
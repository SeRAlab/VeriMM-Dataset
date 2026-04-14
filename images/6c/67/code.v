module top_module(a, out);input [31:0] a; 
  output [31:0] out; 
  wire [31:0] out, temp; 
  assign temp = a; 
  genvar i; 
  generate 
  for(i=0; i<32; i=i+1) begin: reversal_loop 
  assign out[i] = temp[31-i]; 
  end 
  endgenerate 
 endmodule
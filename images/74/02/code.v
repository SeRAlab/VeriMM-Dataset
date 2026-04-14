module top_module(a, lsb, out);input [31:0] a; 
  input lsb; 
  output [31:0] out; 
  wire [31:0] out; 
  genvar i; 
  generate 
  for(i=1; i<32; i=i+1) begin: shift_one_loop 
  assign out[i] = a[i-1]; 
  end 
  endgenerate 
  assign out[0] = lsb; 
 endmodule
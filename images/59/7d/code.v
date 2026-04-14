module top_module(a, lsb, out);input [31:0] a; 
  input lsb; 
  output[31:0] out; 
  wire [31:0] out; 
  genvar i; 
  generate 
  for(i=4; i<32; i=i+1) begin: shift_four_loop 
  assign out[i] = a[i-4]; 
  end 
  endgenerate 
  assign out[0] = lsb; 
  assign out[1] = lsb; 
  assign out[2] = lsb; 
  assign out[3] = lsb; 
 endmodule
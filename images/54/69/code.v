module top_module(bin_val,gray_val);parameter width = 8; 
  input [width-1:0] bin_val; 
  output reg [width-1:0] gray_val; 
  integer i; 
  always @* 
  begin 
  gray_val[width-1] = bin_val[width-1]; 
  for(i=0;i<width-1;i=i+1) 
  gray_val[i] = bin_val[i] ^ bin_val[i+1]; 
  end 
 endmodule
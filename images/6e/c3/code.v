module top_module(
  out    , 
  enable , 
  clk    , 
  rst      
  );input clk, rst, enable; 
  
  output [ 7:0] out;
  
  wire [7:0] out;
  reg [7:0] count;
  
  always @ (posedge clk) 
  if (rst) 
    count <= 0; 
  else if (enable) 
    count <= count + 1; 
    
  assign out = { count[7], (count[7] ^ count[6]),(count[6] ^ 
               count[5]),(count[5] ^ count[4]), (count[4] ^ 
               count[3]),(count[3] ^ count[2]), (count[2] ^ 
               count[1]),(count[1] ^ count[0]) };
    
endmodule
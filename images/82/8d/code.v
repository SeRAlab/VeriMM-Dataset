module top_module(
  clk, 
  rst,
  srst,  
  clk_ena,
  
  
  load,  
  
  carry,  
  
  dfload  
);parameter MOD_COUNT = 4;
  parameter WIDTH = 4;
  input clk, rst, srst, clk_ena;
  
  input load;
  input[WIDTH-1:0] dfload;
  output carry;
    reg carry_tmp;
  assign carry = carry_tmp;
  
  reg [WIDTH-1:0] count;  
  
  always @(posedge clk or posedge rst) begin
    if(rst)
    count <= 0;
  else if(clk_ena)
    if(srst)
      count <= 0;
    else if(load)  
      count <= dfload;
    else
      count <= count-1;
  end
  
  always @(count) begin 
    if(count == 
  0)
  
      carry_tmp = 'b1;
    else 
      carry_tmp = 'b0;  
  end
endmodule
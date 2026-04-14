module top_module(
  clk, rst, clk_ena,
  
  
  load,  
  
  carry,  
  
  dfload,  
  count
);parameter MOD_COUNT = 7;
  parameter WIDTH = 8;
  input clk, rst, clk_ena;
  
  input load;
  input [WIDTH-1:0] dfload;
  output carry;
    reg carry_tmp;
  assign carry = carry_tmp;
  output [WIDTH-1:0] count;
  
  reg [WIDTH-1:0] count_r;  
    assign count = count_r;
  
  always @(posedge clk or posedge rst) begin
    if(rst)
    count_r <= 0;
  else if(clk_ena)
    if(load)  
      count_r <= dfload;
    else
      count_r <= count_r+1;
  end
  
  always @(count_r) begin 
    if(count_r == MOD_COUNT-1)
      carry_tmp = 'b1;
    else 
      carry_tmp = 'b0;  
  end
endmodule
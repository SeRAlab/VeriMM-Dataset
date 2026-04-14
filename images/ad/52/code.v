module top_module(
  output reg [3:0]value,  
  output reg borrow,  
  input clk,
  input rst_n, 
  input decrease,  
  input [3:0]init_value,  
  input [3:0]start_value,
  input [3:0]limit,  
  input restart
);reg [3:0] value_tmp; 

always @*
  if (value == limit && decrease)  
  begin
    value_tmp = start_value;
    borrow = 1'b1;
  end
  else if (decrease) 
  begin
    value_tmp = value - 1'b1;
    borrow = 1'b0;
  end
  else 
  begin
    value_tmp = value;
    borrow = 1'b0;
  end

always @(posedge clk or negedge rst_n)
  if (rst_n==0) value <= init_value;
  else if(restart==1) value <= init_value;
  else value <= value_tmp;

endmodule
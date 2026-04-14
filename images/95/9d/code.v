module top_module(
  input clk,
  input rst,
  input clk_ena,
  input load,
  input [WIDTH-1:0] dfload,
  output carry
);parameter MOD_COUNT = 7;
  parameter WIDTH = 8;

  reg [WIDTH-1:0] count; // counter
  reg carry_tmp; // temporary carry signal

  always @(posedge clk or posedge rst) begin
    if(rst)
      count <= 0;
    else if(clk_ena)
      if(load)
        count <= dfload;
      else
        count <= count+1;
  end

  always @(count) begin
    if(count == MOD_COUNT-1)
      carry_tmp = 1'b1;
    else 
      carry_tmp = 1'b0;
  end

  assign carry = carry_tmp;
endmodule
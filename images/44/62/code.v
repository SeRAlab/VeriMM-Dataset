module top_module(
  clk, rst, clk_ena,
  load, set,
  dfload,
  carry
);parameter WIDTH = 4;
  input clk, rst, clk_ena, load, set;
  input [WIDTH-1:0] dfload;
  output carry;
  reg carry_tmp;
  assign carry = carry_tmp;
  reg [WIDTH-1:0] count;
  
  always @(posedge clk or posedge rst) begin
    if(rst) begin
      count <= 4'b0000;
    end
    else if(clk_ena) begin
      if(set) begin
        count <= 4'b0000;
      end
      else if(load) begin
        count <= dfload;
      end
      else begin
        count <= count - 1;
      end
    end
  end
  
  always @(count) begin
    if(count == 4'b0000) begin
      carry_tmp = 1'b1;
    end
    else begin
      carry_tmp = 1'b0;
    end
  end
endmodule
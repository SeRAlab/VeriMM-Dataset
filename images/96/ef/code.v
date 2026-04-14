module top_module(
  input clk,
  input rst,
  input en,
  input ctrl,
  output [bits-1:0] binary_count,
  output [bits-1:0] gray_count
);parameter bits = 4; // number of bits in the counter
  
  reg [bits-1:0] count_reg;
  reg [bits-1:0] gray_reg;
  
  always @(posedge clk) begin
    if (rst) begin
      count_reg <= 0;
      gray_reg <= 0;
    end else if (en) begin
      if (ctrl) begin
        count_reg <= count_reg + 1;
      end else begin
        count_reg <= count_reg - 1;
      end
      gray_reg <= count_reg ^ (count_reg >> 1);
    end
  end
  
  assign binary_count = count_reg;
  assign gray_count = gray_reg;
  
endmodule
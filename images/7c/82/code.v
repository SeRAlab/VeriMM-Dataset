module top_module(
  input clk,
  input rst,
  input en,
  input dir,
  input [n-1:0] count_in,
  output reg [n-1:0] count_out
);parameter n = 4; // number of bits in the counter

reg [n-1:0] count_reg;

always @(posedge clk) begin
  if (rst) begin
    count_reg <= 0;
  end else if (en) begin
    if (dir) begin // counting up
      if (count_reg == 2**n-1) begin
        count_reg <= 0;
      end else begin
        count_reg <= count_reg + 1;
      end
    end else begin // counting down
      if (count_reg == 0) begin
        count_reg <= 2**n-1;
      end else begin
        count_reg <= count_reg - 1;
      end
    end
  end
end

assign count_out = (en) ? count_reg : count_in;

endmodule
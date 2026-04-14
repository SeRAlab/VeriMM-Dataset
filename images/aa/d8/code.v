module top_module(
  input clk,
  input reset,
  output [3:0] count,
  output reg overflow  // Change from wire to reg
);reg [3:0] count_reg;

always @(posedge clk) begin
  if (reset) begin
    count_reg <= 4'b0;
    overflow <= 1'b0;
  end else if (count_reg == 4'b1001) begin
    count_reg <= 4'b0;
    overflow <= 1'b1;
  end else begin
    count_reg <= count_reg + 1;
    overflow <= 1'b0;
  end
end

assign count = count_reg;

endmodule
module top_module(
  input clk,
  input reset,
  input enable,
  output [3:0] count
);reg [3:0] count_reg;

  always @(posedge clk) begin
    if (reset) begin
      count_reg <= 0;
    end else begin
      if (enable) begin
        if (count_reg == 4'b1111) begin
          count_reg <= 0;
        end else begin
          count_reg <= count_reg + 1;
        end
      end
    end
  end

  assign count = count_reg;

endmodule
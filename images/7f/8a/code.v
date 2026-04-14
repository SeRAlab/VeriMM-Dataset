module top_module(
  input clk,
  input reset,
  input load,
  input direction,
  input [7:0] data_in,
  output reg [7:0] count,
  output carry
);reg [7:0] count_reg;
  reg [7:0] count_next;
  reg carry_reg;

  always @(posedge clk) begin
    if (reset) begin
      count_reg <= 8'b0;
      carry_reg <= 1'b0;
    end
    else if (load) begin
      count_reg <= data_in;
      carry_reg <= (data_in == 8'hFF) ? 1'b1 : 1'b0;
    end
    else begin
      count_reg <= count_next;
      carry_reg <= (count_next == 8'hFF) ? 1'b1 : 1'b0;
    end
  end

  always @(*) begin
    if (direction) begin
      count_next = count_reg + 1;
    end
    else begin
      count_next = count_reg - 1;
    end
  end

  assign count = count_reg;
  assign carry = carry_reg;

endmodule
module top_module(
  input clk,
  input reset,
  input [7:0] data_in,
  output reg parity_out
);reg [7:0] data_reg;
  reg [7:0] data_reg2;
  reg parity_reg;

  always @(posedge clk) begin
    if (reset) begin
      data_reg <= 8'b0;
      data_reg2 <= 8'b0;
      parity_reg <= 1'b0;
      parity_out <= 1'b0;
    end
    else begin
      data_reg <= data_in;
      data_reg2 <= data_reg;
      parity_reg <= ~(^data_reg2);
      parity_out <= parity_reg;
    end
  end

endmodule
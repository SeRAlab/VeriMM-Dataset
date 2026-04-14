module top_module(
  input clk,
  input reset,
  input [3:0] data_in,
  output reg [3:0] data_out
);reg [7:0] shift_reg;

  always @(posedge clk) begin
    if (reset) begin
      shift_reg <= 0;
    end else begin
      shift_reg <= {shift_reg[6:0], data_in};
    end
  end

  assign data_out = shift_reg[3:0];

endmodule
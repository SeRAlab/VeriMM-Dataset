module top_module(
  input [n-1:0] data_in,
  input clk,
  input reset,
  input shift_en,
  output [n-1:0] data_out
);parameter n = 8; // number of bits in the shift register

reg [n-1:0] shift_reg;

always @(posedge clk) begin
  if (reset) begin
    shift_reg <= 0;
  end else if (shift_en) begin
    shift_reg <= {shift_reg[n-2:0], 1'b0};
  end else begin
    shift_reg <= shift_reg;
  end
end

assign data_out = shift_reg;

endmodule
module top_module(
  input data_in,
  input clk,
  input reset,
  input shift,
  output reg data_out
);parameter n = 8; // number of bits in the shift register

reg [n-1:0] shift_reg;

always @(posedge clk) begin
  if (reset) begin
    shift_reg <= 0;
  end else if (shift) begin
    shift_reg <= {shift_reg[n-2:0], data_in};
  end else begin
    shift_reg <= shift_reg;
  end
end

assign data_out = shift_reg[n-1];

endmodule
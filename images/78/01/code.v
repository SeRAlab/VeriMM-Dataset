module top_module(
  input clk,
  input data_in,
  input shift_en,
  input reset,
  output reg data_out
);parameter n = 8; // number of bits in the shift register

reg [n-1:0] shift_reg;

always @(posedge clk) begin
  if (reset) begin
    shift_reg <= 0;
    data_out <= 0;
  end
  else if (shift_en) begin
    shift_reg <= {shift_reg[n-2:0], data_in};
    data_out <= shift_reg[n-1];
  end
end

endmodule
module top_module(
  input in,
  input clk,
  input rst,
  output out
);parameter n = 8; // number of bits in the shift register

reg [n-1:0] shift_reg; // register to hold the current state of the shift register

always @(posedge clk) begin
  if (rst) begin
    shift_reg <= 0; // clear the shift register
  end else begin
    shift_reg <= {shift_reg[n-2:0], in}; // shift in the input signal
  end
end

assign out = shift_reg[n-1]; // output the most significant bit

endmodule
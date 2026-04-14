module top_module(
  input clk,               // Added clk input
  input [n-1:0] in,
  output [n-1:0] out
);parameter n = 8; // number of bits in the signal
parameter d = 4; // delay of the circuit in clock cycles

reg [n-1:0] shift_reg [0:d-1]; // Declare shift register array

always @(posedge clk) begin
  // Shift the register
  shift_reg[0] <= in; // Input goes into the first register
  for (integer i = 1; i < d; i = i + 1) begin
    shift_reg[i] <= shift_reg[i-1]; // Shift the values
  end
end

assign out = shift_reg[d-1]; // Output is the last register value

endmodule
module top_module(
  input inp,
  output reg out
);parameter n = 4; // length of shift register
parameter seq = "0011"; // desired input sequence (binary string)

reg [n-1:0] shift_reg; // shift register

// Define the predefined states that correspond to the desired input sequence
parameter [n-1:0] state_1 = 4'b0011; // 0011
parameter [n-1:0] state_2 = 4'b0110; // 110 -> shifted left
parameter [n-1:0] state_3 = 4'b1100; // 1100 -> shifted left
parameter [n-1:0] state_4 = 4'b1001; // 1001 -> shifted left

always @(posedge inp) begin
  // Shift the input into the shift register
  shift_reg <= {shift_reg[n-2:0], inp};
  
  // Compare the current state of the shift register to the predefined states
  if (shift_reg == state_1 || shift_reg == state_2 || shift_reg == state_3 || shift_reg == state_4) begin
    out <= 1; // Output a logic 1 if the current state matches one of the predefined states
  end else begin
    out <= 0; // Output a logic 0 otherwise
  end
end

endmodule
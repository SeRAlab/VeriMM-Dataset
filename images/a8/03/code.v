module top_module(
  input D,
  input C,
  input R,
  input P,
  output reg Q // Changed to 'reg' since Q will be assigned in an always block
);wire not_R = ~R;
  wire not_P = ~P;
  wire reset = not_R & C;
  wire preset = not_P & C;

  // Implementing the behavior of a D flip-flop with preset and clear
  always @(posedge C or posedge preset or posedge reset) begin
    if (preset)
      Q <= 1'b1; // Set Q to 1 when preset is active
    else if (reset)
      Q <= 1'b0; // Clear Q when reset is active
    else
      Q <= D; // Set Q to D on the rising edge of clock C
  end

endmodule
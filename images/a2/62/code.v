module top_module(
  input signed [3:0] A,
  input signed [3:0] B,
  input mode,
  output reg signed [3:0] result  // Changed wire to reg
);wire [3:0] twos_comp_B;
  assign twos_comp_B = (~B) + 1;

  always @(*) begin
    if (mode) begin
      result = A + B;
    end else begin
      result = A + twos_comp_B;
    end
  end

endmodule
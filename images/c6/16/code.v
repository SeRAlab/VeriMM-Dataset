module parity_generator (
  input in1,
  input in2,
  input in3,
  input in4,
  output reg parity
);

  always @ (in1, in2, in3, in4) begin
    if ((in1 + in2 + in3 + in4) % 2 == 0)
      parity <= 0;
    else
      parity <= 1;
  end

endmodule

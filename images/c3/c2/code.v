module d_latch(
  input D,
  input C,
  output Q
);

  reg Q;

  always @(posedge C) begin
    if (C) begin
      Q <= D;
    end
  end

endmodule
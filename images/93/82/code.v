module top_module(
  input D,
  input EN,
  input RST,
  output Q
);reg Q_reg;

  always @ (posedge EN) begin
    if (RST) begin
      Q_reg <= 1'b0;
    end else begin
      Q_reg <= D;
    end
  end

  assign Q = Q_reg;

endmodule
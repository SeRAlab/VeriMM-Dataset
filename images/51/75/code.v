module top_module(
  input CK, D, RN, SN, TE, TI,
  output Q
);reg Q_reg;
  wire Q_next;

  // Implement the flip-flop with active-low reset and set
  always @(posedge CK or negedge RN or negedge SN) begin
    if (!RN) begin
      Q_reg <= 0;
    end else if (!SN) begin
      Q_reg <= 1;
    end else if (!TE) begin
      // Do nothing
    end else begin
      Q_reg <= D;
    end
  end

  // Implement the TI control signal
  assign Q_next = (TI) ? D : Q_reg;

  // Implement the output Q
  assign Q = Q_next;

endmodule
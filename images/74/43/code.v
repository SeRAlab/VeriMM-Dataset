module top_module(
  output reg Q,
  input D,
  input CLK,
  input SET,
  input SLEEP_B,
  output reg NOTIFIER
);reg Q_;
  wire SET_;

  assign SET_ = ~SET;

  always @(posedge CLK) begin
    if (SLEEP_B) begin
      Q_ <= SET_ ? 1'b1 : D;
    end
  end

  always @(SET) begin
    if (SET) begin
      Q_ <= 1'b1;
      NOTIFIER <= 1'b1;
    end else begin
      NOTIFIER <= 1'b0;
    end
  end

  always @(Q_) begin
    Q <= SLEEP_B ? Q_ : Q_;
  end

endmodule
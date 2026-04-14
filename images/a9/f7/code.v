module top_module(
  input CLK,
  input D,
  input EN,
  input SET,
  input RESET,
  output reg Q,
  output reg Q_bar
);always @(posedge CLK) begin
    if (EN) begin
      if (SET) begin
        Q <= 1'b1;
      end else if (RESET) begin
        Q <= 1'b0;
      end else begin
        Q <= D;
      end
    end
  end

  assign Q_bar = ~Q;

endmodule
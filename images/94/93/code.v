module top_module(
  input D,
  input SET_B,
  input RESET_B,
  input CTRL,
  input CLK,
  output reg Q,
  output reg Q_N
);always @(posedge CLK or negedge RESET_B or negedge SET_B or negedge CTRL) begin
    if (!RESET_B) begin
      Q <= 0;
      Q_N <= 1;
    end else if (!SET_B) begin
      Q <= 1;
      Q_N <= 0;
    end else if (!CTRL) begin
      Q <= D;
      Q_N <= ~D;
    end else begin
      Q <= 0;
      Q_N <= 1;
    end
  end

endmodule
module top_module(
  input D, J, K, T, S, R, CLK,
  output reg Q_D, Q_JK, Q_T, Q_SR // Changed outputs to reg type
);// D flip-flop (positive edge-triggered)
always @(posedge CLK) begin
  Q_D <= D;
end

// JK flip-flop (negative edge-triggered)
always @(negedge CLK) begin
  if (J && !K) begin
    Q_JK <= 1;
  end else if (!J && K) begin
    Q_JK <= 0;
  end else if (J && K) begin
    Q_JK <= ~Q_JK;
  end
end

// T flip-flop (positive edge-triggered)
always @(posedge CLK) begin
  if (T) begin
    Q_T <= ~Q_T;
  end
end

// SR flip-flop (negative edge-triggered)
always @(negedge CLK) begin
  if (S && !R) begin
    Q_SR <= 1;
  end else if (!S && R) begin
    Q_SR <= 0;
  end else if (S && R) begin
    Q_SR <= 'bx; // undefined state
  end
end

endmodule
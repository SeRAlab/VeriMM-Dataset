module top_module(
  input D, CLK, CLR, PR,
  output Q, Q_not
);// D flip-flop inputs and outputs
reg D_FF, Q_FF, Q_not_FF;
always @(posedge CLK, posedge CLR, posedge PR) begin
  if (CLR) begin
    Q_FF <= 0;
    Q_not_FF <= 1;
  end else if (PR) begin
    Q_FF <= 1;
    Q_not_FF <= 0;
  end else begin
    Q_FF <= D_FF;
    Q_not_FF <= ~D_FF;
  end
end
assign Q = Q_FF;
assign Q_not = Q_not_FF;

// JK flip-flop inputs and outputs
reg J_FF, K_FF;
always @(posedge CLK, posedge CLR, posedge PR) begin
  if (CLR) begin
    Q_FF <= 0;
    Q_not_FF <= 1;
  end else if (PR) begin
    Q_FF <= 1;
    Q_not_FF <= 0;
  end else begin
    if (J_FF && K_FF) begin
      Q_FF <= ~Q_FF;
      Q_not_FF <= ~Q_not_FF;
    end else if (J_FF) begin
      Q_FF <= 1;
      Q_not_FF <= 0;
    end else if (K_FF) begin
      Q_FF <= 0;
      Q_not_FF <= 1;
    end
  end
end

// T flip-flop inputs and outputs
reg T_FF;
always @(posedge CLK, posedge CLR, posedge PR) begin
  if (CLR) begin
    Q_FF <= 0;
    Q_not_FF <= 1;
  end else if (PR) begin
    Q_FF <= 1;
    Q_not_FF <= 0;
  end else begin
    if (T_FF) begin
      Q_FF <= ~Q_FF;
      Q_not_FF <= ~Q_not_FF;
    end
  end
end

// SR flip-flop inputs and outputs
reg S_FF, R_FF;
always @(posedge CLK, posedge CLR, posedge PR) begin
  if (CLR) begin
    Q_FF <= 0;
    Q_not_FF <= 1;
  end else if (PR) begin
    Q_FF <= 1;
    Q_not_FF <= 0;
  end else begin
    if (S_FF) begin
      Q_FF <= 1;
      Q_not_FF <= 0;
    end else if (R_FF) begin
      Q_FF <= 0;
      Q_not_FF <= 1;
    end
  end
end

endmodule
module top_module(T, S, R, CLK, Q, QN);input T, S, R, CLK;
  output Q, QN;
  reg Q, QN;

  always @(posedge CLK) begin
    if (S) begin
      Q <= 1;
      QN <= 0;
    end else if (R) begin
      Q <= 0;
      QN <= 1;
    end else if (T) begin
      Q <= ~Q;
      QN <= ~QN;
    end
  end
endmodule
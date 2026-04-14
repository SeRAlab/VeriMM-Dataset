module top_module(D, G, RN, Q, QN);input D;
  input G;
  input RN;
  output Q;
  output QN;
  reg Q, QN;

  always @ (D, G, RN) begin
    if (RN == 1'b0) begin
      Q <= 1'b0;
      QN <= 1'b1;
    end else if (G == 1'b0) begin
      Q <= 1'b0;
      QN <= 1'b1;
    end else begin
      Q <= D;
      QN <= ~D;
    end
  end

endmodule
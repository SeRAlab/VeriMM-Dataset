module top_module(CKN, D, SN, Q, QN);input CKN, D, SN;
  output Q, QN;
  reg Q, QN;

  always @(posedge CKN, posedge SN) begin
    if (SN) begin
      Q <= 1'b1;
      QN <= 1'b0;
    end else begin
      Q <= D;
      QN <= ~D;
    end
  end

endmodule
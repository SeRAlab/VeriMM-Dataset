module top_module(Ck, Ckn, D, Rn, Q, Qn);input Ck, Ckn, D, Rn;
  output Q, Qn;
  reg Q, Qn;
  always @(posedge Ck) begin
    if (!Rn) begin
      Q <= 1'b0;
      Qn <= 1'b1;
    end else if (!Ckn) begin
      Q <= Q;
      Qn <= Qn;
    end else begin
      Q <= D;
      Qn <= ~D;
    end
  end
endmodule
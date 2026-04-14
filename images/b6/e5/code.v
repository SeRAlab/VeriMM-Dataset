module top_module(CK, J, K, RN, Q, QN);input CK;
input J;
input K;
input RN;
output Q;
output QN;
reg Q;
reg QN;

always @ (posedge CK or negedge RN) begin
  if (RN == 0) begin
    Q <= 0;
    QN <= 1;
  end else begin
    if (J == 1 && K == 0) begin
      Q <= 1;
    end else if (J == 0 && K == 1) begin
      Q <= 0;
    end else if (J == 1 && K == 1) begin
      Q <= ~Q;
    end
    QN <= ~Q;
  end
end

endmodule
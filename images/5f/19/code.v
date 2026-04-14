module top_module(CK, D, RST, Q, QN);input CK, D, RST;
output Q, QN;
reg Q, QN;

always @(posedge CK or negedge RST) begin
  if (!RST) begin
    Q <= 0;
    QN <= 1;
  end
  else begin
    Q <= D;
    QN <= ~D;
  end
end

endmodule
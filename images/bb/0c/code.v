module top_module(D, S, R, CLK, Q, QN);input D;
input S;
input R;
input CLK;
output Q;
output QN;

reg Q;
reg QN;

always @(posedge CLK) begin
  if (S == 1'b1) begin
    Q <= 1'b1;
    QN <= 1'b0;
  end else if (R == 1'b1) begin
    Q <= 1'b0;
    QN <= 1'b1;
  end else begin
    Q <= D ^ Q;
    QN <= ~Q;
  end
end

endmodule
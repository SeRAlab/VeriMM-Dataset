module top_module(CLK, CLR, PRE, D, Q, QN);input CLK, CLR, PRE, D;
output Q, QN;
reg Q, QN;

always @(posedge CLK or negedge CLR or negedge PRE) begin
  if (CLR == 0) begin
    Q <= 0;
    QN <= 1;
  end else if (PRE == 0) begin
    Q <= 1;
    QN <= 0;
  end else begin
    Q <= D;
    QN <= ~D;
  end
end

endmodule
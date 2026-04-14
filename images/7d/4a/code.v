module top_module(D, GN, Q, QN);input  D ;
input  GN ;
output Q ;
output QN ;
reg Q_reg, QN_reg;

always @ (posedge GN or negedge D) begin
  if (GN == 1'b0) begin
    Q_reg <= Q_reg;
    QN_reg <= QN_reg;
  end else begin
    Q_reg <= D;
    QN_reg <= ~D;
  end
end

assign Q = Q_reg;
assign QN = QN_reg;

endmodule
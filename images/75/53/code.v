module top_module(R, S, D, Q, QN, clk);input  R;
input  S;
input  D;
input  clk;  // Added clk input
output Q;
output QN;
reg    Q;
reg    QN;
reg    NOTIFIER;

always @(posedge clk) begin
   if (R) begin
      Q <= 1'b0;
      QN <= 1'b1;
   end else if (S) begin
      Q <= 1'b1;
      QN <= 1'b0;
   end else begin
      Q <= D;
      QN <= ~D;
   end
end

endmodule
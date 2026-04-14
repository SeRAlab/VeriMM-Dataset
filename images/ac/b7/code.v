module top_module(CK, D, S, R, Q, QN);input  CK ;
input  D ;
input  S ;
input  R ;
output Q ;
output QN ;
reg    Q ;

always @(posedge CK)
begin
   if (S)
      Q <= 1'b1;
   else if (R)
      Q <= 1'b0;
   else
      Q <= D;
end

assign QN = ~Q;

endmodule
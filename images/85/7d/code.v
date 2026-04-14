module top_module(D, S, R, G, Q, QN);input  D ;
input  S ;
input  R ;
input  G ;
output Q ;
output QN ;
reg Q;

always @(posedge G)
begin
    if (R == 1'b1)
        Q <= 1'b0;
    else if (S == 1'b1)
        Q <= 1'b1;
    else
        Q <= D;
end

assign QN = ~Q;

endmodule
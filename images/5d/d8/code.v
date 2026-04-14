module top_module(CK, D, S, R, C, Q, QN);input  CK ;
input  D ;
input  S ;
input  R ;
input  C ;
output Q ;
output QN ;
reg Q, QN;

always @(posedge CK) begin
    if (C) begin
        Q <= 1'b0;
        QN <= 1'b1;
    end else if (S) begin
        Q <= 1'b1;
        QN <= 1'b0;
    end else if (R) begin
        Q <= 1'b0;
        QN <= 1'b1;
    end else begin
        Q <= D;
        QN <= ~D;
    end
end

endmodule
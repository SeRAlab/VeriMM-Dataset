module top_module(CK, D, RN, SN, Q, QN);input  CK ;
input  D ;
input  RN ;
input  SN ;
output Q ;
output QN ;
reg Q;

always @ (posedge CK) begin
    if (RN) begin
        Q <= 1'b0;
    end else if (SN) begin
        Q <= 1'b1;
    end else begin
        Q <= D;
    end
end

assign QN = ~Q;

endmodule
module top_module(CK, D, RN, SN, TE, TI, Q);input  CK ;
input  D ;
input  RN ;
input  SN ;
input  TE ;
input  TI ;
output Q ;
reg NOTIFIER ;
reg [1:0] Q_reg;
reg [1:0] Q_next;

always @(posedge CK) begin
    if (RN) begin
        Q_reg <= 0;
    end else if (SN) begin
        Q_reg <= 1;
    end else if (TE) begin
        Q_reg <= Q_next;
    end else begin
        Q_reg <= D;
    end
end

always @(posedge CK) begin
    Q_next <= Q_reg;
end

assign Q = Q_reg[0];

endmodule
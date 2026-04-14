module top_module(
    Q      ,
    RESET_B,
    D      ,
    GATE
);output Q      ;
    input  RESET_B;
    input  D      ;
    input  GATE   ;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    reg Q_reg;
    always @(posedge GATE) begin
        if(RESET_B == 1'b0) begin
            Q_reg <= 1'b0;
        end
        else begin
            Q_reg <= D;
        end
    end
    assign Q = Q_reg;

endmodule
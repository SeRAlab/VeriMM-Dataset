module top_module(
    Q       ,
    RESET_B ,
    D       ,
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
    always @(posedge GATE or negedge RESET_B) begin
        if (RESET_B == 0) begin
            Q_reg <= 0;
        end
        else if (GATE == 1) begin
            Q_reg <= D;
        end
    end

    assign Q = GATE ? Q_reg : 0;

endmodule
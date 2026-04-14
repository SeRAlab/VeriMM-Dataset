module sky130_fd_sc_ms__dlrtp (
    Q      ,
    RESET_B,
    D      ,
    GATE
);

    output Q      ;
    input  RESET_B;
    input  D      ;
    input  GATE   ;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    reg Q_reg;

    always @ (RESET_B or D or GATE) begin
        if (RESET_B == 1'b1) begin
            Q_reg <= 1'b0;
        end else if (GATE == 1'b1) begin
            Q_reg <= D;
        end
    end

    assign Q = GATE ? Q_reg : Q;

endmodule
module sky130_fd_sc_ls__dlrtn_1 (
    Q      ,
    RESET_B,
    D      ,
    GATE_N ,
    VPWR   ,
    VGND   ,
    VPB    ,
    VNB
);

    output Q      ;
    input  RESET_B;
    input  D      ;
    input  GATE_N ;
    input  VPWR   ;
    input  VGND   ;
    input  VPB    ;
    input  VNB    ;

    reg Q_int;

    always @(*) begin
        if(RESET_B == 1'b1) begin
            Q_int = 1'b0;
        end
        else if(GATE_N == 1'b1) begin
            Q_int = D;
        end
        else begin
            Q_int = 1'b1;
        end
    end

    assign Q = Q_int;

endmodule
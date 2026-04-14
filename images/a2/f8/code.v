module top_module(
    Q      ,
    CLK    ,
    D      ,
    RESET_B,
    VPWR   ,
    VGND   ,
    VPB    ,
    VNB
);output Q      ;
    input  CLK    ;
    input  D      ;
    input  RESET_B;
    input  VPWR   ;
    input  VGND   ;
    input  VPB    ;
    input  VNB    ;

    // Using a generic D flip-flop with reset instead of missing module
    reg Q_reg;
    
    always @(posedge CLK or negedge RESET_B) begin
        if (!RESET_B)
            Q_reg <= 1'b0;
        else
            Q_reg <= D;
    end

    assign Q = Q_reg;

endmodule
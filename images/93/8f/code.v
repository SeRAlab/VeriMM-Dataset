module top_module(
    Q      ,
    CLK    ,
    D      ,
    SCD    ,
    SCE    ,
    RESET_B,
    VPWR   ,
    VGND   ,
    VPB    ,
    VNB
);output Q      ;
    input  CLK    ;
    input  D      ;
    input  SCD    ;
    input  SCE    ;
    input  RESET_B;
    input  VPWR   ;
    input  VGND   ;
    input  VPB    ;
    input  VNB    ;

    reg Q;

    always @(posedge CLK, negedge RESET_B) begin
        if (!RESET_B) begin
            Q <= 1'b0;
        end else if (SCD == 1'b0) begin
            Q <= 1'b0;
        end else if (SCE == 1'b1) begin
            Q <= D;
        end
    end

endmodule
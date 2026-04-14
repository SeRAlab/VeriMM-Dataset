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

    always @(posedge CLK or negedge RESET_B or posedge SCD or posedge SCE) begin
        if (!RESET_B) begin
            Q <= 0;
        end else if (SCD) begin
            Q <= ~Q;
        end else if (SCE) begin
            Q <= D;
        end
    end

endmodule
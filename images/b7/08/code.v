module top_module(
    Q      ,
    Q_N    ,
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
    output Q_N    ;
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
    reg Q_N;

    always @(posedge CLK) begin
        if (RESET_B == 0) begin
            Q <= 0;
            Q_N <= 1;
        end else if (SCD == 1 && SCE == 0) begin
            Q <= 0;
            Q_N <= 1;
        end else if (SCD == 1 && SCE == 1) begin
            Q <= 1;
            Q_N <= 0;
        end else if (SCD == 0 && SCE == 1) begin
            Q <= 1;
            Q_N <= 0;
        end else if (D == 1) begin
            Q <= 1;
            Q_N <= 0;
        end else begin
            Q <= Q;
            Q_N <= Q_N;
        end
    end

endmodule
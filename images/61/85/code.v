module top_module(
    Q      ,
    Q_N    ,
    D      ,
    SCD    ,
    SCE    ,
    CLK    ,
    SET_B  ,
    RESET_B,
    VPWR   ,
    VGND   ,
    VPB    ,
    VNB
);output Q      ;
    output Q_N    ;
    input  D      ;
    input  SCD    ;
    input  SCE    ;
    input  CLK    ;
    input  SET_B  ;
    input  RESET_B;
    input  VPWR   ;
    input  VGND   ;
    input  VPB    ;
    input  VNB    ;

    reg Q;
    wire Q_N;

    assign Q_N = ~Q;

    always @ (posedge CLK) begin
        if (SCE) begin
            Q <= D;
        end
    end

    always @ (posedge CLK) begin
        if (SCD) begin
            Q <= 0;
        end
    end

    always @ (SET_B or RESET_B) begin
        if (~SET_B) begin
            Q <= 1;
        end else if (~RESET_B) begin
            Q <= 0;
        end
    end

endmodule
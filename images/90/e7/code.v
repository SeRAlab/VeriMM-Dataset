module top_module(
    Q      ,
    Q_N    ,
    D      ,
    SCD    ,
    SCE    ,
    CLK_N  ,
    SET_B  ,
    RESET_B
);output Q      ;
    output Q_N    ;
    input  D      ;
    input  SCD    ;
    input  SCE    ;
    input  CLK_N  ;
    input  SET_B  ;
    input  RESET_B;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    reg Q;
    reg Q_N;

    always @(negedge CLK_N) begin
        if (SCD == 1'b1) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end
        else if (SCE == 1'b1) begin
            Q <= 1'b1;
            Q_N <= 1'b0;
        end
        else if (SET_B == 1'b0) begin
            Q <= 1'b1;
            Q_N <= 1'b0;
        end
        else if (RESET_B == 1'b0) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end
        else begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule
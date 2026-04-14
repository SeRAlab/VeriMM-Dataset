module top_module(
    Q      ,
    CLK_N  ,
    D      ,
    SCD    ,
    SCE    ,
    RESET_B
);output Q      ;
    input  CLK_N  ;
    input  D      ;
    input  SCD    ;
    input  SCE    ;
    input  RESET_B;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    reg Q;

    always @(negedge CLK_N) begin
        if(RESET_B == 1'b0) begin
            Q <= 1'b0;
        end else if(SCD == 1'b1) begin
            Q <= 1'b0;
        end else if(SCE == 1'b0) begin
            Q <= Q;
        end else begin
            Q <= D;
        end
    end

endmodule
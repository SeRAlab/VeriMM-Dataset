module top_module(
    Q      ,
    Q_N    ,
    D      ,
    SCD    ,
    SCE    ,
    CLK_N  ,
    SET_B  ,
    RESET_B,
    VPWR   ,
    VGND   ,
    VPB    ,
    VNB
);output reg Q      ;   // Change to 'reg' to match the assignment style
    output reg Q_N    ;   // Change to 'reg' to match the assignment style
    input  D          ;
    input  SCD        ;
    input  SCE        ;
    input  CLK_N      ;
    input  SET_B      ;
    input  RESET_B    ;
    input  VPWR       ;
    input  VGND       ;
    input  VPB        ;
    input  VNB        ;
    
    always @ (posedge CLK_N or negedge SET_B or negedge RESET_B) begin
        if (RESET_B == 1'b0) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end else if (SET_B == 1'b0) begin
            Q <= 1'b1;
            Q_N <= 1'b0;
        end else if (SCE) begin
            Q <= D;
            Q_N <= ~D;
        end else if (SCD) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end
    end

    always @* begin
        Q_N = ~Q;  // Drive Q_N based on Q
    end

endmodule
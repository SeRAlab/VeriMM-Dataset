module top_module(
    RESET_B,
    CLK_N  ,
    D      ,
    Q      ,
    SCD    ,
    SCE    ,
    VPWR   ,
    VGND
);input  RESET_B;
    input  CLK_N  ;
    input  D      ;
    output Q      ;
    input  SCD    ;
    input  SCE    ;
    input  VPWR   ;
    input  VGND   ;

    reg q_reg;
    wire d_ff;
    wire s_ff;

    assign d_ff = SCE ? SCD : D;

    always @(posedge CLK_N, negedge RESET_B) begin
        if (~RESET_B) begin
            q_reg <= 1'b0;
        end else begin
            q_reg <= d_ff;
        end
    end

    assign Q = q_reg;

endmodule
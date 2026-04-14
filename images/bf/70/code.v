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
    VGND
);output Q      ;
    output Q_N    ;
    input  D      ;
    input  SCD    ;
    input  SCE    ;
    input  CLK_N  ;
    input  SET_B  ;
    input  RESET_B;
    input  VPWR   ;
    input  VGND   ;

    reg Q_reg, Q_N_reg;

    always @(posedge CLK_N or negedge RESET_B or negedge SET_B) begin
        if (~SET_B) begin
            Q_reg <= 1;
            Q_N_reg <= 0;
        end else if (~RESET_B) begin
            Q_reg <= 0;
            Q_N_reg <= 1;
        end else begin
            Q_reg <= D;
            Q_N_reg <= ~D;
        end
    end

    assign Q = Q_reg;
    assign Q_N = Q_N_reg;

endmodule
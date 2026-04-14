module top_module(
    output Q      ,
    output Q_N    ,
    input  D      ,
    input  SCD    ,
    input  SCE    ,
    input  CLK_N  ,
    input  SET_B  ,
    input  RESET_B
);reg Q_reg, Q_N_reg;
    wire SCD_N, SCE_N, SET_N, RESET_N;
    assign SCD_N = ~SCD;
    assign SCE_N = ~SCE;
    assign SET_N = ~SET_B;
    assign RESET_N = ~RESET_B;

    always @(posedge CLK_N) begin
        if (SCD) begin
            Q_reg <= 1'b0;
            Q_N_reg <= 1'b1;
        end else if (SCE) begin
            Q_reg <= 1'b1;
            Q_N_reg <= 1'b0;
        end else begin
            Q_reg <= D;
            Q_N_reg <= ~D;
        end
    end

    assign Q = (SET_B == 1'b0) ? 1'b1 : Q_reg;
    assign Q_N = (RESET_B == 1'b0) ? 1'b1 : Q_N_reg;

endmodule
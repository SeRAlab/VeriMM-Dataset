module top_module(
    RESET_B,
    CLK    ,
    D      ,
    Q      ,
    SCD    ,
    SCE
);input  RESET_B;
    input  CLK    ;
    input  D      ;
    output Q      ;
    input  SCD    ;
    input  SCE    ;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    reg q_reg;

    always @(posedge CLK) begin
        if(RESET_B == 0) begin
            q_reg <= 0;
        end else if(SCD == 1) begin
            q_reg <= 0;
        end else if(SCE == 1) begin
            q_reg <= 1;
        end else begin
            q_reg <= D;
        end
    end

    assign Q = q_reg;

endmodule
module top_module(
    Q      ,
    CLK    ,
    D      ,
    SCD    ,
    SCE    ,
    RESET_B
);// Module ports
    output Q      ;
    input  CLK    ;
    input  D      ;
    input  SCD    ;
    input  SCE    ;
    input  RESET_B;

    // Local signals
    reg Q_reg;

    // Update Q on rising edge of CLK
    always @(posedge CLK or negedge RESET_B) begin
        if (!RESET_B) begin
            Q_reg <= 1'b0;
        end else if (SCD) begin
            Q_reg <= D;
        end else if (SCE) begin
            Q_reg <= 1'b0;
        end
    end

    // Assign Q
    assign Q = Q_reg;

endmodule
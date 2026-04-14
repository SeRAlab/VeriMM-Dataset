module top_module(
    Q      ,
    Q_N    ,
    CLK    ,
    D      ,
    RESET_B
);output Q      ;
    output Q_N    ;
    input  CLK    ;
    input  D      ;
    input  RESET_B;

    reg Q;

    always @(posedge CLK or negedge RESET_B) begin
        if (RESET_B == 0) begin
            Q <= 0;
        end else begin
            Q <= D;
        end
    end

    assign Q_N = ~Q;

endmodule
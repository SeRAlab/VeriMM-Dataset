module d_latch (
    Q      ,
    Q_N    ,
    RESET_B,
    D      ,
    GATE
);

    output Q      ;
    output Q_N    ;
    input  RESET_B;
    input  D      ;
    input  GATE   ;

    reg Q, Q_N;

    always @(negedge RESET_B or posedge GATE) begin
        if (!RESET_B) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end else if (GATE) begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule
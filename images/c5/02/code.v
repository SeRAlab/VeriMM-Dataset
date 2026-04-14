module d_ff_async_reset_set (
    input D,
    input CLK,
    input RESET,
    input SET,
    output Q,
    output Q_N
);

    reg Q;
    wire Q_N;

    assign Q_N = ~Q;

    always @(posedge CLK or negedge RESET or negedge SET) begin
        if (!RESET) begin
            Q <= 0;
        end else if (!SET) begin
            Q <= 1;
        end else begin
            Q <= D;
        end
    end

endmodule
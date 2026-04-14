module d_latch (
    input CLK,
    input D,
    input RESET,
    input EN,
    output reg Q,
    output reg Q_N
);

    always @(posedge CLK) begin
        if (RESET) begin
            Q <= 0;
            Q_N <= 1;
        end else if (EN) begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule
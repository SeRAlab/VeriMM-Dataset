module top_module(
    input CLK,
    input D,
    input RESET,
    input EN,
    output reg Q,   // Change to output reg
    output reg Q_N  // Change to output reg
);always @(posedge CLK or negedge RESET)
begin
    if (!RESET)
    begin
        Q <= 1'b0;
        Q_N <= 1'b1;
    end
    else if (!EN)
    begin
        Q <= Q;  // This effectively does nothing; it can be optimized out
        Q_N <= Q_N; // This can also be optimized out
    end
    else
    begin
        Q <= D;
        Q_N <= ~D;
    end
end

endmodule
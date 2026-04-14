module d_ff_async_reset_set (
    input CLK,
    input D,
    input RESET,
    input SET,
    output Q,
    output QN
);

reg Q;

always @(posedge CLK, negedge RESET, negedge SET) begin
    if (!RESET) // asynchronous reset
        Q <= 1'b0;
    else if (!SET) // asynchronous set
        Q <= 1'b1;
    else // normal operation
        Q <= D;
end

assign QN = ~Q;

endmodule
module top_module(
    input CLK,
    input D,
    input SET,
    output reg Q
);always @(posedge CLK)
begin
    if (SET == 1)   // Asynchronous set
        Q <= 1;
    else            // Synchronous update
        Q <= D;
end

endmodule
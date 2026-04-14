module top_module(
    input CLK,
    input D,
    input RESET,
    input SET,
    output reg Q,    // Change Q to reg type
    output QN
);always @(posedge CLK or negedge RESET or negedge SET) begin
    if (!RESET) // asynchronous reset
        Q <= 1'b0;
    else if (!SET) // asynchronous set
        Q <= 1'b1;
    else // normal operation
        Q <= D;
end

assign QN = ~Q;

endmodule
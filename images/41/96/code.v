module top_module(
    input D,
    input CLK,
    input RESET,
    input EN,
    output reg Q
);always @(posedge CLK or negedge RESET)
    if (!RESET)
        Q <= 1'b0;
    else if (EN)
        Q <= D;

endmodule
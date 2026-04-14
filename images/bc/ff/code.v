module lfsr (
    input clk,
    input reset,
    output reg [7:0] q);always @(posedge clk or posedge reset)
    if (reset)
        q <= 8'h1; // Non-zero initial state
    else
        q <= {q[6:0], q[7] ^ q[5]}; // Example polynomial x^8 + x^6 + 1

endmodule
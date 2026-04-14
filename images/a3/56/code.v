module johnson_counter_3bit(
    input clk,
    input reset,
    output reg [2:0] q
);

always @(posedge clk or posedge reset)
    if (reset)
        q <= 3'b000; // Reset state
    else
        q <= {~q[2], q[2:1]}; // Johnson counter sequence

endmodule
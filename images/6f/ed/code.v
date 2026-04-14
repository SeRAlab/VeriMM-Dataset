module ring_counter_10bit(
    input clk,
    input reset,
    output reg [9:0] q
);

always @(posedge clk or posedge reset)
    if (reset)
        q <= 10'b0000000001; // Reset state
    else
        q <= {q[8:0], q[9]}; // Ring counter sequence

endmodule
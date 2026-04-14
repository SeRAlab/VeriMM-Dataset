module up_down_counter_16bit(
    input clk,
    input reset,
    input enable,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk or posedge reset)
    if (reset)
        count <= 16'b0000000000000000; // Reset count to 0
    else if (enable)
        if (up_down)
            count <= count + 1; // Increment count
        else
            count <= count - 1; // Decrement count

endmodule
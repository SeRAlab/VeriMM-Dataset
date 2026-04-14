module up_counter_4bit(
    input clk,
    input reset,
    input enable,
    output reg [3:0] count
);

always @(posedge clk or posedge reset)
    if (reset)
        count <= 4'b0000; // Reset count to 0
    else if (enable)
        count <= count + 1; // Increment count

endmodule
module down_counter_8bit(
    input clk,
    input reset,
    input enable,
    output reg [7:0] count
);

always @(posedge clk or posedge reset)
    if (reset)
        count <= 8'b11111111; // Reset count to 255
    else if (enable)
        count <= count - 1; // Decrement count

endmodule
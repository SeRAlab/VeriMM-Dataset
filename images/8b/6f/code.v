module up_counter_with_load(
    input clk,
    input reset,
    input enable,
    input load,
    input [7:0] load_value,
    output reg [7:0] count
);

always @(posedge clk or posedge reset)
    if (reset)
        count <= 8'b00000000; // Reset count to 0
    else if (load)
        count <= load_value; // Load given value
    else if (enable)
        count <= count + 1; // Increment count

endmodule
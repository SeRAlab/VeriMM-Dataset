module register_16bit(
    input clk,
    input reset,
    input enable,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk)
    if (reset)
        q <= 16'b0; // Reset to 0
    else if (enable)
        q <= d; // Load input data

endmodule
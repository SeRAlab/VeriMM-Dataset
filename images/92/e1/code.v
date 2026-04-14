module shift_register_8bit(
    input clk,
    input load,
    input [7:0] parallel_in,
    output reg [7:0] q
);

always @(posedge clk)
    if (load)
        q <= parallel_in; // Load parallel input
    else
        q <= {1'b0, q[7:1]}; // Shift right

endmodule
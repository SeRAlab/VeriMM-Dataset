module shift_register_8bit(
    input clk,
    input serial_in,
    output reg [7:0] parallel_out
);

always @(posedge clk)
    parallel_out <= {parallel_out[6:0], serial_in}; // Shift left and insert new bit

endmodule
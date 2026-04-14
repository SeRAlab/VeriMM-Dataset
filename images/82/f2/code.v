module shift_register(
    input clk,               // Clock signal.
    input rst_n,             // Active-low reset signal.
    input load,              // Parallel load signal.
    input shift_right,       // Shift direction control signal. 1 for right shift, 0 for left shift.
    input [7:0] parallel_in, // 8-bit parallel input data.

    output [7:0] q           // 8-bit shift register output.
);

reg [7:0] q_r; // Shift register output register.

//------------------------------------------------
// Perform shift register operations
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q_r <= 8'h00;
    else if (load)
        q_r <= parallel_in;
    else if (shift_right)
        q_r <= q_r >> 1;
    else
        q_r <= q_r << 1;
end

assign q = q_r;

endmodule
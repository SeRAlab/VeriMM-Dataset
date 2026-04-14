module shift_register_16bit(
    input clk,           // Clock signal.
    input rst,           // Reset signal.
    input shift_en,      // Shift enable signal.
    input load_en,       // Load enable signal.
    input [15:0] parallel_in, // 16-bit parallel input.

    output [15:0] q      // 16-bit output representing the current state of the shift register.
);

reg [15:0] q_r; // Shift register.

//------------------------------------------------
// Shift register operation
always @(posedge clk) begin
    if (rst) begin
        q_r <= 16'b0000000000000000; // Reset shift register to 0
    end
    else if (load_en) begin
        q_r <= parallel_in; // Load parallel input into the shift register
    end
    else if (shift_en) begin
        q_r <= {q_r[14:0], 1'b0}; // Shift left by one bit
    end
end

assign q = q_r;

endmodule
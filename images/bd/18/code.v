module lfsr_16bit(
    input clk,           // Clock signal.
    input rst_n,         // Active-low reset signal.
    input [15:0] seed,   // 16-bit seed value for initializing the LFSR.

    output [15:0] lfsr_out // 16-bit LFSR output.
);

reg [15:0] lfsr_r; // LFSR register.
wire feedback;

//------------------------------------------------
// LFSR polynomial tap configuration for pseudo-random number generation
assign feedback = lfsr_r[15] ^ lfsr_r[13] ^ lfsr_r[12] ^ lfsr_r[10]; // Example polynomial: x^16 + x^14 + x^13 + x^11 + 1

//------------------------------------------------
// Perform LFSR operations
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        lfsr_r <= seed;
    else begin
        lfsr_r <= {lfsr_r[14:0], feedback};
    end
end

assign lfsr_out = lfsr_r;

endmodule
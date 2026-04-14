module random_sampler (
    input [7:0] x_range_min,
    input [7:0] x_range_max,
    input [7:0] y_range_min,
    input [7:0] y_range_max,
    input clk,
    output reg [7:0] x_coord,
    output reg [7:0] y_coord
);
    // Simple random sampling using a shift register (not true randomness)
    reg [15:0] lfsr; // Linear Feedback Shift Register for pseudo-random generation
    initial begin
        lfsr = 16'hACE1; // Seed value
    end

    always @(posedge clk) begin
        lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]}; // Feedback
        x_coord <= x_range_min + (lfsr[7:0] % (x_range_max - x_range_min + 1));
        y_coord <= y_range_min + (lfsr[15:8] % (y_range_max - y_range_min + 1));
    end
endmodule
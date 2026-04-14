module lfsr (
    input wire clk,
    input wire rst,
    input wire [7:0] seed,
    output reg [7:0] lfsr_out,
    output reg cycle_completed
);
    reg [7:0] lfsr;
    reg [7:0] prev_lfsr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= seed;
            cycle_completed <= 0;
        end else begin
            prev_lfsr <= lfsr;
            lfsr[0] <= lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[6]; // Feedback polynomial
            lfsr[7:1] <= lfsr[6:0]; // Shift
            lfsr_out <= lfsr;
            if (lfsr == prev_lfsr) begin
                cycle_completed <= 1; // Indicate one full cycle completion
            end else begin
                cycle_completed <= 0;
            end
        end
    end
endmodule
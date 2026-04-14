module rng_lfsr(
    input clk,
    input rst,
    input [3:0] seed,
    output reg [3:0] random_number
);
    reg [3:0] lfsr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= seed; // Load the seed value on reset
        end else begin
            // Shift left and feedback according to the polynomial x^4 + x^3 + 1
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
        end
    end

    always @(posedge clk) begin
        random_number <= lfsr; // Output the current state of LFSR
    end
endmodule
module CSPRNG (
    input wire clk,
    input wire reset,
    input wire [4:0] seed,
    output reg [4:0] random_out
);
    reg [4:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= seed; // Load the seed
        end else begin
            // Shift and feedback calculation for a 5-bit LFSR with taps at positions 5 and 3
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2]};
        end
    end

    always @(posedge clk) begin
        random_out <= lfsr; // Output the current state of LFSR
    end
endmodule
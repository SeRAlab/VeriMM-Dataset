module CSPRNG (
    input wire clk,
    input wire reset,
    input wire [7:0] seed,
    output reg random_bit
);

reg [7:0] lfsr;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        lfsr <= seed; // Initialize LFSR with seed
        random_bit <= 0;
    end else begin
        // LFSR feedback polynomial: x^8 + x^6 + x^5 + x^4 + 1
        random_bit <= lfsr[0]; // Output current bit
        lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[0]}; // Shift and feedback
    end
end

endmodule
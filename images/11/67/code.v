module rng_lfsr(
    input clk,
    input reset,
    input [3:0] seed,
    output reg rand_bit
);
    reg [3:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= seed;
            rand_bit <= 0;
        end else begin
            // Feedback polynomial: x^4 + x^3 + 1 
            rand_bit <= lfsr[0]; // output the least significant bit
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]}; // Shift and feedback
        end
    end
endmodule
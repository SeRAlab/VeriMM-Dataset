module lfsr_16_bit (
    input clk,
    input reset,
    output reg [15:0] lfsr
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 16'h1; // Initialize to a non-zero value
        end else begin
            // Feedback polynomial: x^16 + x^14 + x^13 + x^11 + 1
            lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
        end
    end
endmodule
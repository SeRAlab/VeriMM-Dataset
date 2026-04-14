module lfsr_8bit(
    input clk,
    input reset,
    output reg [7:0] lfsr
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 8'b1; // Initialize to a non-zero state
        end else begin
            // Feedback polynomial: x^8 + x^6 + x^5 + x^4 + 1
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
        end
    end
endmodule
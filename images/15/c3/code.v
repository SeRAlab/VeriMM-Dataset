module csprng(
    input clk,
    input reset,
    output reg random_bit
);
    reg [4:0] lfsr; // 5-bit LFSR

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 5'b00001; // Initial seed
        end else begin
            // Feedback polynomial: x^5 + x^3 + 1
            random_bit <= lfsr[0]; // Output the least significant bit
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2]}; // Shift and feedback
        end
    end
endmodule
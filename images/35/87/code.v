module lfsr (
    input clk,
    input rst,
    output reg [4:0] lfsr_out
);

    // Initial seed value
    initial begin
        lfsr_out = 5'b00001; // Example initial seed
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_out <= 5'b00001; // Reset to initial seed
        end else begin
            // Feedback polynomial: x^5 + x^3 + 1
            lfsr_out <= {lfsr_out[3], lfsr_out[2], lfsr_out[1], lfsr_out[0], lfsr_out[4] ^ lfsr_out[2]};
        end
    end
endmodule
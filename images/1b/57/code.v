module rng_lfsr (
    input clk,
    input rst,
    output reg [4:0] random_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            random_out <= 5'b00001; // Initial state
        end else begin
            // Feedback polynomial: x^5 + x^4 + x^3 + x^2 + 1
            random_out <= {random_out[3:0], random_out[4] ^ random_out[3] ^ random_out[2] ^ random_out[1]};
        end
    end
endmodule
module rng_lfsr(
    input clk,
    input reset,
    output reg [4:0] random_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            random_out <= 5'b00001; // Initial seed
        end else begin
            random_out <= {random_out[3:0], random_out[4] ^ random_out[1]}; // Feedback
        end
    end
endmodule
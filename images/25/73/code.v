module LFSR (
    input clk,
    input rst,
    input load,
    input [15:0] seed,
    output reg [15:0] lfsr_out
);
    wire feedback;

    // Feedback polynomial: x^16 + x^14 + x^13 + x^11 + 1
    assign feedback = lfsr_out[15] ^ lfsr_out[13] ^ lfsr_out[12] ^ lfsr_out[10];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_out <= 16'h1; // Default seed
        end else if (load) begin
            lfsr_out <= seed; // Load new seed
        end else begin
            lfsr_out <= {lfsr_out[14:0], feedback}; // Shift and insert feedback
        end
    end
endmodule
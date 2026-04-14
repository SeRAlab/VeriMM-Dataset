module lfsr_32bit (
    input wire clk,
    input wire reset,
    input wire [31:0] seed,
    output reg [31:0] lfsr_out
);
    wire feedback;

    // Feedback polynomial: x^32 + x^22 + x^18 + x^17 + x^13 + 1
    assign feedback = lfsr_out[31] ^ lfsr_out[21] ^ lfsr_out[17] ^ lfsr_out[16] ^ lfsr_out[12];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= seed; // Load the seed on reset
        end else begin
            lfsr_out <= {lfsr_out[30:0], feedback}; // Shift and feedback
        end
    end
endmodule
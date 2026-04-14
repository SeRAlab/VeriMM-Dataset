module lfsr (
    input wire clk,
    input wire reset,
    output reg [15:0] lfsr_out
);

    wire feedback;
    assign feedback = lfsr_out[15] ^ lfsr_out[13] ^ lfsr_out[12] ^ lfsr_out[10];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 16'b1; // Initialize with a non-zero seed
        end else begin
            lfsr_out <= {lfsr_out[14:0], feedback}; // Shift left and insert feedback
        end
    end
endmodule
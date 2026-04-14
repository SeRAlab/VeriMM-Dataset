module lfsr_5bit (
    input wire clk,
    input wire reset,
    input wire seed,
    output reg [4:0] lfsr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= seed ? 5'b00001 : 5'b00000; // Initialize with seed
        end else begin
            lfsr_out <= {lfsr_out[3:0], lfsr_out[4] ^ lfsr_out[2]}; // Feedback from taps
        end
    end
endmodule
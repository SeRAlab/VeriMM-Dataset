module LFSR (
    input clk,
    input rst,
    input [4:0] seed,
    output reg [4:0] lfsr_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_out <= seed; // Load seed on reset
        end else begin
            lfsr_out <= {lfsr_out[3:0], lfsr_out[4] ^ lfsr_out[3]}; // Shift and feedback
        end
    end
endmodule
module lfsr_32bit (
    input clk,
    input rst,
    output reg [31:0] lfsr_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_out <= 32'h1; // Initial value
        end else begin
            lfsr_out <= {lfsr_out[30:0], lfsr_out[31] ^ lfsr_out[21] ^ lfsr_out[1] ^ lfsr_out[0]}; // Feedback taps
        end
    end
endmodule
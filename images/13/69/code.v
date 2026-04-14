module lfsr_5bit (
    input clk,
    input reset,
    output reg [4:0] lfsr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 5'b00001; // Initial seed
        end else begin
            lfsr_out <= {lfsr_out[3:0], lfsr_out[4] ^ lfsr_out[2]}; // Feedback polynomial x^5 + x^3 + 1
        end
    end
endmodule
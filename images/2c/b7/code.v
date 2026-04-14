module lfsr_8bit (
    input clk,
    input rst,
    input enable,
    output reg [7:0] lfsr_out
);
    initial begin
        lfsr_out = 8'b00000001; // Initial value
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_out <= 8'b00000001; // Reset to initial value
        end else if (enable) begin
            // LFSR feedback polynomial: x^8 + x^6 + x^5 + x^4 + 1
            lfsr_out <= {lfsr_out[6:0], lfsr_out[7] ^ lfsr_out[5] ^ lfsr_out[4] ^ lfsr_out[3]};
        end
    end
endmodule
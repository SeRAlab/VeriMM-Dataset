module lfsr(
    input wire clk,
    input wire rst,
    input wire enable,
    output reg [7:0] lfsr_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_out <= 8'b1; // Initial state
        end else if (enable) begin
            lfsr_out <= {lfsr_out[6:0], lfsr_out[7] ^ lfsr_out[5] ^ lfsr_out[4] ^ lfsr_out[6]};
        end
    end
endmodule
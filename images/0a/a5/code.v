module lfsr(
    input clk,
    input rst,
    input [7:0] seed,
    output reg [7:0] lfsr_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        lfsr_out <= seed; // Load seed value on reset
    end else begin
        lfsr_out <= {lfsr_out[6:0], lfsr_out[7] ^ lfsr_out[5] ^ lfsr_out[4] ^ lfsr_out[0]}; // Shift and feedback
    end
end

endmodule
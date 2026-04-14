module LFSR_5bit(
    input wire clk,
    input wire rst,
    output reg [4:0] lfsr_out
);
    // Define the initial seed value
    initial begin
        lfsr_out = 5'b00001; // Non-zero seed
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_out <= 5'b00001; // Reset to seed value
        end else begin
            // LFSR feedback computation
            lfsr_out <= {lfsr_out[3:0], lfsr_out[4] ^ lfsr_out[2]};
        end
    end
endmodule
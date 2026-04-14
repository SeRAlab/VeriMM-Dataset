module lfsr (
    input clk,
    input rst,
    output reg [3:0] lfsr_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_out <= 4'b0001; // Initialize to a non-zero value
        end else begin
            // Feedback from tap positions 4 and 3
            lfsr_out <= {lfsr_out[2:0], lfsr_out[3] ^ lfsr_out[2]};
        end
    end
endmodule
module lfsr(
    input clk,
    input reset,
    input enable,
    output reg [3:0] lfsr_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 4'b0001; // Initialize to a non-zero value
        end else if (enable) begin
            // Feedback from taps 4 and 3
            lfsr_out <= {lfsr_out[2:0], lfsr_out[3] ^ lfsr_out[2]};
        end
    end
endmodule
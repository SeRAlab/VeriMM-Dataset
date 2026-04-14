module lfsr (
    input clk,
    input reset,
    input load,
    input [4:0] load_value,
    output reg [4:0] lfsr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 5'b00001; // Initial state after reset
        end else if (load) begin
            lfsr_out <= load_value; // Load new value
        end else begin
            // Feedback based on polynomial x^5 + x^2 + 1
            lfsr_out <= {lfsr_out[3:0], lfsr_out[4] ^ lfsr_out[1]};
        end
    end
endmodule
module lfsr(
    input wire clk,
    input wire reset,
    output reg [4:0] lfsr_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 5'b00001; // Initial state
        end else begin
            // Feedback polynomial: x^5 + x^4 + x^3 + 1
            lfsr_out <= {lfsr_out[3:0], lfsr_out[4] ^ lfsr_out[3] ^ lfsr_out[2]};
        end
    end
endmodule
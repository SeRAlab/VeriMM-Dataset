module lfsr (
    input clk,
    input reset,
    output reg [4:0] lfsr_out
);
    wire feedback;

    assign feedback = lfsr_out[4] ^ lfsr_out[1]; // x^5 + x^2 + 1 feedback

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 5'b00001; // Initial seed value
        end else begin
            lfsr_out <= {lfsr_out[3:0], feedback}; // Shift left and insert feedback
        end
    end
endmodule
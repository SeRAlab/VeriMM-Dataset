module LFSR_32bit (
    input wire clk,
    input wire reset,
    output reg [31:0] lfsr_out
);
    wire feedback;
    
    // Feedback polynomial: x^32 + x^22 + x^21 + x^17 + 1 (example polynomial)
    assign feedback = lfsr_out[31] ^ lfsr_out[21] ^ lfsr_out[20] ^ lfsr_out[16];
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 32'hFFFFFFFF; // Initialize LFSR with non-zero value
        end else begin
            lfsr_out <= {lfsr_out[30:0], feedback}; // Shift left and insert feedback
        end
    end
endmodule
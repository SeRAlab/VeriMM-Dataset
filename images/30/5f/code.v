module lfsr_32bit (
    input clk,
    input rst,
    output reg [31:0] lfsr_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_out <= 32'hFFFFFFFF; // Initialize the LFSR with a non-zero value
        end else begin
            // Feedback polynomial: x^32 + x^22 + x^21 + x^17 + 1
            lfsr_out <= {lfsr_out[30:0], 
                          lfsr_out[31] ^ lfsr_out[21] ^ lfsr_out[20] ^ lfsr_out[16]};
        end
    end
endmodule
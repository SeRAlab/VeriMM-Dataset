module lfsr_32bit (
    input clk,
    input rst,
    input [31:0] seed,
    output reg [31:0] out
);
    // Polynomial: x^32 + x^22 + x^23 + x^17 + 1
    wire feedback = out[31] ^ out[22] ^ out[23] ^ out[17];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= seed; // Load seed on reset
        end else begin
            out <= {out[30:0], feedback}; // Shift left and insert feedback
        end
    end
endmodule